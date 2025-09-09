package com.rnwrap

import android.content.Context
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import com.smileidentity.models.AutoCapture
import com.smileidentity.results.DocumentVerificationResult
import com.smileidentity.util.randomJobId
import com.smileidentity.util.randomUserId
import java.io.File
import kotlinx.collections.immutable.ImmutableMap
import kotlinx.collections.immutable.persistentMapOf

class DocumentVerificationView(context: Context) :
  SmileIDComposeHostView(
    context = context,
    shouldUseAndroidLayout = true
  ) {
  var countryCode by mutableStateOf("KE")
  var userId by mutableStateOf<String?>(null)
  var jobId by mutableStateOf<String?>(null)
  var allowNewEnroll by mutableStateOf<Boolean?>(null)
  var documentType by mutableStateOf<String?>(null)
  var idAspectRatio by mutableStateOf<Float?>(null)
  var bypassSelfieCaptureWithFile by mutableStateOf<String?>(null)
  var autoCaptureTimeout by mutableStateOf<Int?>(null) // seconds
  var autoCapture by mutableStateOf<String?>(null) // 'auto' | 'manual'
  var captureBothSides by mutableStateOf<Boolean?>(null)
  var allowAgentMode by mutableStateOf<Boolean?>(null)
  var allowGalleryUpload by mutableStateOf<Boolean?>(null)
  var showInstructions by mutableStateOf<Boolean?>(null)
  var showAttribution by mutableStateOf<Boolean?>(null)
  var useStrictMode by mutableStateOf<Boolean?>(null)
  var extraPartnerParams by mutableStateOf<ImmutableMap<String, String>>(persistentMapOf())
  var skipApiSubmission by mutableStateOf<Boolean?>(null)

  @Composable
  override fun Content() {
    DocumentVerificationRootView(
      countryCode = countryCode,
      documentType = documentType,
      captureBothSides = captureBothSides ?: true,
      idAspectRatio = idAspectRatio,
      bypassSelfieCaptureWithFile = bypassSelfieCaptureWithFile?.let { File(it) },
      userId =  userId ?: randomUserId(),
      jobId = jobId ?: randomJobId(),
      autoCaptureTimeoutSeconds = autoCaptureTimeout ?: 10,
      autoCapture = when (autoCapture) {
        "AutoCaptureOnly" -> AutoCapture.AutoCaptureOnly
        "ManualCaptureOnly" -> AutoCapture.ManualCaptureOnly
        "AutoCapture" -> AutoCapture.AutoCapture
        else -> AutoCapture.AutoCapture
      },
      allowNewEnroll = allowNewEnroll ?: false,
      showAttribution = showAttribution ?: true,
      allowAgentMode = allowAgentMode ?: false,
      allowGalleryUpload = allowGalleryUpload ?: false,
      showInstructions = showInstructions ?: true,
      useStrictMode = useStrictMode ?: false,
      extraPartnerParams = extraPartnerParams,
      onResult = { result: DocumentVerificationResult ->
        dispatchDirectEvent(eventPropName = "onSuccess", payload = result.toWritableMap())
      },
      onError = { throwable: Throwable ->
        dispatchDirectEvent(eventPropName = "onError", payload = throwable.toDocumentVerificationErrorPayload())
      }
    )
  }
}
