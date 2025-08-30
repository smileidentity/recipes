package com.rnwrapperrecipe

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.RnWrapperRecipeViewManagerInterface
import com.facebook.react.viewmanagers.RnWrapperRecipeViewManagerDelegate

@ReactModule(name = RnWrapperRecipeViewManager.NAME)
class RnWrapperRecipeViewManager : SimpleViewManager<RnWrapperRecipeView>(),
  RnWrapperRecipeViewManagerInterface<RnWrapperRecipeView> {
  private val mDelegate: ViewManagerDelegate<RnWrapperRecipeView>

  init {
    mDelegate = RnWrapperRecipeViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<RnWrapperRecipeView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): RnWrapperRecipeView {
    return RnWrapperRecipeView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: RnWrapperRecipeView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "RnWrapperRecipeView"
  }
}
