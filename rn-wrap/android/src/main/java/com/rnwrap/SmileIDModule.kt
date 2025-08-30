package com.rnwrap

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.bridge.ReadableMap
import com.facebook.react.bridge.UiThreadUtil
import com.smileidentity.SmileID
import java.net.URL

class SmileIDModule(reactContext: ReactApplicationContext) : ReactContextBaseJavaModule(reactContext) {
  override fun getName(): String = "SmileID"

  @ReactMethod
  fun setCallbackUrl(url: String?, promise: Promise) {
    try {
      UiThreadUtil.runOnUiThread {
        try {
          SmileID.setCallbackUrl(URL(url))
          promise.resolve(null)
        } catch (e: Throwable) {
          promise.reject("setCallbackUrl_error", e)
        }
      }
    } catch (e: Throwable) {
      promise.reject("setCallbackUrl_error", e)
    }
  }

  @ReactMethod
  fun initialize(
    useSandbox: Boolean,
    enableCrashReporting: Boolean,
    config: ReadableMap?,
    apiKey: String?,
    promise: Promise
  ) {
    // For safety, run SDK initialization on the UI thread to avoid UI access on background threads
    try {
      UiThreadUtil.runOnUiThread {
        try {
          // Fallbacks similar to iOS: attempt richest path first. For now, we call the basic
          // initialize(useSandbox) which is sufficient for Compose flows. If needed, we can
          // extend this to pass apiKey/config when SDK signatures are confirmed.
          SmileID.initialize(context = reactApplicationContext, useSandbox = useSandbox)
          // Optionally enable crash reporting if the SDK respects it internally after initialize.
          // Some SDK versions may automatically handle crash reporting on initialize.
          promise.resolve(null)
        } catch (e: Throwable) {
          promise.reject("initialize_error", e)
        }
      }
    } catch (e: Throwable) {
      promise.reject("initialize_error", e)
    }
  }
}
