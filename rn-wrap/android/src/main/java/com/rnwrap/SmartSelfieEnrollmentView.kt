package com.rnwrap

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.results.SmartSelfieResult

class SmartSelfieEnrollmentView(context: Context) :
  SmileIDComposeHostView(
    context = context,
    shouldUseAndroidLayout = true
  ) {
  @Composable
  override fun Content() {
    SmartSelfieEnrollmentRootView(
      onResult = { result: SmartSelfieResult ->
        dispatchDirectEvent(eventPropName = "onSuccess", payload = result.toWritableMap())
      },
      onError = { throwable: Throwable ->
        dispatchDirectEvent(eventPropName = "onError", payload = throwable.toSmartSelfieErrorPayload())
      }
    )
  }
}
