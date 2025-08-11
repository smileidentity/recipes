package com.rnwrapperrecipe

import android.content.Context
import android.util.AttributeSet
import androidx.compose.runtime.Composable
import com.smileidentity.results.SmartSelfieResult

class SmartSelfieAuthenticationView(context: Context) :
  SmileIDComposeHostView(
    context = context,
    shouldUseAndroidLayout = true
  ) {

  @Composable
  override fun Content() {
    SmartSelfieAuthenticationRootView(
      onResult = { result: SmartSelfieResult ->
        dispatchDirectEvent(eventPropName = "onSuccess", payload = result.toWritableMap())
      },
      onError = { throwable: Throwable ->
        dispatchDirectEvent(eventPropName = "onError", payload = throwable.toSmartSelfieErrorPayload())
      }
    )
  }
}
