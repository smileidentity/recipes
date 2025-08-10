import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate;
import com.facebook.react.viewmanagers.SmartSelfieAuthenticationViewManagerInterface;
import com.facebook.react.viewmanagers.SmartSelfieAuthenticationViewManagerDelegate;
import com.rnwrapperrecipe.SmartSelfieAuthenticationView

@ReactModule(name = SmartSelfieAuthenticationViewManager.REACT_CLASS)
class SmartSelfieAuthenticationViewManager: SimpleViewManager<SmartSelfieAuthenticationView>(),
  SmartSelfieAuthenticationViewManagerInterface<SmartSelfieAuthenticationView> {
  private val delegate: SmartSelfieAuthenticationViewManagerDelegate<SmartSelfieAuthenticationView, SmartSelfieAuthenticationViewManager> =
    SmartSelfieAuthenticationViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<SmartSelfieAuthenticationView> = delegate

  override fun getName(): String = REACT_CLASS

  override fun createViewInstance(context: ThemedReactContext): SmartSelfieAuthenticationView {
    return SmartSelfieAuthenticationView(context)
  }

  companion object {
    const val REACT_CLASS = "SmartSelfieAuthenticationView"
  }
}
