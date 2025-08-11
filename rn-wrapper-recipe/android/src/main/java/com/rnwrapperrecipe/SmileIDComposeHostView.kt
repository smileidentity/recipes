package com.rnwrapperrecipe

import android.content.Context
import android.view.View
import android.widget.LinearLayout
import androidx.annotation.UiThread
import androidx.compose.runtime.Composable
import androidx.compose.ui.platform.ComposeView
import androidx.compose.ui.platform.ViewCompositionStrategy
import androidx.fragment.app.FragmentActivity
import androidx.lifecycle.ViewModelStore
import androidx.lifecycle.ViewModelStoreOwner
import androidx.lifecycle.setViewTreeViewModelStoreOwner
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.ReactContext
import com.facebook.react.bridge.WritableMap
import com.facebook.react.uimanager.UIManagerHelper
import com.facebook.react.uimanager.events.Event
import com.facebook.react.uimanager.events.RCTEventEmitter

/**
 * Base host for SmileID Compose content inside a React Native Fabric view.
 * - Provides a ViewModelStoreOwner (FragmentActivity if available, else a custom store)
 * - Sets composition strategy and disposes on detach
 * - Clears custom ViewModelStore to prevent retained state between mounts
 *
 * Extend this class and implement Content() to render your Composable.
 *  @param shouldUseAndroidLayout If set to `true`, the view utilizes the Android layout system rather than React Native's.
 *   This simulates rendering the native view by Android outside of React Native's view hierarchy,
 *   with parent dimensions enforced by Yoga.
 *
 *   Setting it to `true` does not guarantee that the layout calculated by Android will be accurate.
 *   In some situations, the content may render outside the bounds defined by Yoga.
 *
 *   However, without this setting, React Native will not re-render your view when [requestLayout] is triggered.
 *   Read more: [React Native issue #17968](https://github.com/facebook/react-native/issues/17968)
 */
abstract class SmileIDComposeHostView(
  context: Context,
  private val shouldUseAndroidLayout: Boolean = false
) : LinearLayout(context) {

  init {
    configure(context)
  }

  private var customViewModelStoreOwner: ViewModelStoreOwner? = null


  // Remove this incomplete comment entirely

  @Composable
  protected abstract fun Content()

  private fun configure(context: Context) {
    layoutParams = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)

    val composeView = ComposeView(context).apply {
      layoutParams = LayoutParams(LayoutParams.WRAP_CONTENT, LayoutParams.WRAP_CONTENT)
      setViewCompositionStrategy(ViewCompositionStrategy.DisposeOnDetachedFromWindow)
      setupViewModelStoreOwner(this)
      // Qualify to call the host's Composable, not ComposeView.Content (which would recurse)
      setContent { this@SmileIDComposeHostView.Content() }

      addOnAttachStateChangeListener(object : OnAttachStateChangeListener {
        override fun onViewAttachedToWindow(v: View) { /* no-op */
        }

        override fun onViewDetachedFromWindow(v: View) {
          disposeComposition()
          cleanup()
        }
      })
    }
    addView(composeView)
  }

  private fun setupViewModelStoreOwner(composeView: ComposeView) {
    val owner: ViewModelStoreOwner = when (val ctx = context) {
      is FragmentActivity -> ctx
      else -> object : ViewModelStoreOwner {
        override val viewModelStore: ViewModelStore = ViewModelStore()
      }.also { customViewModelStoreOwner = it }
    }
    composeView.setViewTreeViewModelStoreOwner(owner)
  }

  private fun cleanup() {
    customViewModelStoreOwner?.viewModelStore?.clear()
    customViewModelStoreOwner = null
  }

  /**
   * Dispatch a typed direct event to JS using RN's EventDispatcher.
   * The event prop names come from codegen (e.g., onSuccess/onError), and the
   * native event name is the prop name prefixed with "top" (e.g., topOnSuccess).
   */
  protected fun dispatchDirectEvent(eventPropName: String, payload: WritableMap = Arguments.createMap()) {
    val reactContext = UIManagerHelper.getReactContext(this)
    val viewTag = id
    val surfaceId = UIManagerHelper.getSurfaceId(this)
    val dispatcher = UIManagerHelper.getEventDispatcherForReactTag(reactContext, viewTag)
    dispatcher?.dispatchEvent(SimpleMapEvent(surfaceId, viewTag, eventPropName, payload))
  }

  private class SimpleMapEvent(
    surfaceId: Int,
    private val viewTag: Int,
    private val eventName: String,
    private val payload: WritableMap
  ) : Event<SimpleMapEvent>(surfaceId, viewTag) {
    override fun getEventName(): String = eventName
    override fun canCoalesce(): Boolean = false
    override fun dispatch(rctEventEmitter: RCTEventEmitter) {
      rctEventEmitter.receiveEvent(viewTag, eventName, payload)
    }
  }

  override fun requestLayout() {
    super.requestLayout()
    if (shouldUseAndroidLayout) {
      // We need to force measure and layout, because React Native doesn't do it for us.
      post(Runnable { measureAndLayout() })
    }
  }

  /**
   * Manually trigger measure and layout.
   * If [shouldUseAndroidLayout] is set to `true`, this method will be called automatically after [requestLayout].
   */
  @UiThread
  fun measureAndLayout() {
    measure(
      MeasureSpec.makeMeasureSpec(width, MeasureSpec.EXACTLY),
      MeasureSpec.makeMeasureSpec(height, MeasureSpec.EXACTLY)
    )
    layout(left, top, right, bottom)
  }

  override fun onDetachedFromWindow() {
    super.onDetachedFromWindow()
    removeAllViews()
    cleanup()
  }
}
