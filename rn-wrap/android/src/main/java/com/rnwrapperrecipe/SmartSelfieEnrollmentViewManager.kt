package com.rnwrapperrecipe

import com.facebook.react.module.annotations.ReactModule;
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.viewmanagers.SmartSelfieEnrollmentViewManagerInterface
import com.facebook.react.viewmanagers.SmartSelfieEnrollmentViewManagerDelegate
@ReactModule(name = SmartSelfieEnrollmentViewManager.REACT_CLASS)
class SmartSelfieEnrollmentViewManager: SimpleViewManager<SmartSelfieEnrollmentView>(),
  SmartSelfieEnrollmentViewManagerInterface<SmartSelfieEnrollmentView> {
  private val delegate: SmartSelfieEnrollmentViewManagerDelegate<SmartSelfieEnrollmentView, SmartSelfieEnrollmentViewManager> =
    SmartSelfieEnrollmentViewManagerDelegate(this)

  override fun getDelegate(): ViewManagerDelegate<SmartSelfieEnrollmentView> = delegate

  override fun getName(): String = REACT_CLASS

  override fun createViewInstance(context: ThemedReactContext): SmartSelfieEnrollmentView {
    return SmartSelfieEnrollmentView(context)
  }

  companion object {
    const val REACT_CLASS = "SmartSelfieEnrollmentView"
  }
}
