package com.rnwrapperrecipe

import android.content.Context
import androidx.compose.runtime.Composable
import com.smileidentity.results.DocumentVerificationResult

class DocumentVerificationView(context: Context) :
  SmileIDComposeHostView(
    context = context,
    shouldUseAndroidLayout = true
  ) {

  @Composable
  override fun Content() {
    DocumentVerificationRootView(
      onResult = { result: DocumentVerificationResult ->
        dispatchDirectEvent(eventPropName = "onSuccess", payload = result.toWritableMap())
      },
      onError = { throwable: Throwable ->
        dispatchDirectEvent(eventPropName = "onError", payload = throwable.toDocumentVerificationErrorPayload())
      }
    )
  }
}
