package com.rnwrap

import com.facebook.react.ReactPackage
import com.facebook.react.bridge.NativeModule
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.uimanager.ViewManager
import java.util.ArrayList

class RnWrapperRecipeViewPackage : ReactPackage {
  override fun createViewManagers(reactContext: ReactApplicationContext): List<ViewManager<*, *>> {
    val viewManagers: MutableList<ViewManager<*, *>> = ArrayList()
    viewManagers.add(RnWrapViewManager())
    viewManagers.add(DocumentVerificationViewManager())
    viewManagers.add(SmartSelfieAuthenticationViewManager())
    viewManagers.add(SmartSelfieEnrollmentViewManager())
    return viewManagers
  }

  override fun createNativeModules(reactContext: ReactApplicationContext): List<NativeModule> {
  val modules: MutableList<NativeModule> = ArrayList()
  modules.add(SmileIDModule(reactContext))
  return modules
  }
}
