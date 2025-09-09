package com.rnwrap

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import com.smileidentity.SmileID
import com.smileidentity.compose.DocumentVerification
import com.smileidentity.models.AutoCapture
import kotlin.time.Duration.Companion.seconds
import com.smileidentity.results.DocumentVerificationResult
import kotlinx.collections.immutable.ImmutableMap

@Composable
fun DocumentVerificationRootView(
  countryCode: String,
  documentType: String?,
  captureBothSides: Boolean,
  idAspectRatio: Float?,
  bypassSelfieCaptureWithFile: java.io.File?,
  userId: String,
  jobId: String,
  autoCaptureTimeoutSeconds: Int,
  autoCapture: AutoCapture,
  allowNewEnroll: Boolean,
  showAttribution: Boolean,
  allowAgentMode: Boolean,
  allowGalleryUpload: Boolean,
  showInstructions: Boolean,
  useStrictMode: Boolean,
  extraPartnerParams: ImmutableMap<String, String>,
  onResult: (DocumentVerificationResult) -> Unit,
  onError: (Throwable) -> Unit
) {
  Column (
    modifier = Modifier
      .fillMaxSize(),
    horizontalAlignment = Alignment.CenterHorizontally,
    verticalArrangement = Arrangement.Center
  ) {
    SmileID.DocumentVerification(
      countryCode = countryCode,
      documentType = documentType,
      captureBothSides = captureBothSides,
      idAspectRatio = idAspectRatio,
      bypassSelfieCaptureWithFile = bypassSelfieCaptureWithFile,
      userId = userId,
      jobId = jobId,
      autoCaptureTimeout = autoCaptureTimeoutSeconds.seconds,
      autoCapture = autoCapture,
      allowNewEnroll = allowNewEnroll,
      showAttribution = showAttribution,
      allowAgentMode = allowAgentMode,
      allowGalleryUpload = allowGalleryUpload,
      showInstructions = showInstructions,
      useStrictMode = useStrictMode,
      extraPartnerParams = extraPartnerParams,
    ) { result ->
      result.handle(
        onSuccess = onResult,
        onError = onError
      )
    }
  }
}
