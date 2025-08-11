package com.rnwrapperrecipe

import android.os.Parcelable
import com.facebook.react.bridge.Arguments
import com.facebook.react.bridge.WritableMap
import com.smileidentity.results.DocumentVerificationResult
import com.smileidentity.results.SmileIDResult
import com.smileidentity.results.SmartSelfieResult
import org.json.JSONArray
import org.json.JSONObject

/**
 * Concise success/error folding for SmileID Compose results.
 */
inline fun <T : Parcelable> SmileIDResult<T>.handle(
  onSuccess: (T) -> Unit,
  onError: (Throwable) -> Unit
) {
  when (this) {
    is SmileIDResult.Success -> onSuccess(data)
    is SmileIDResult.Error -> onError(throwable)
  }
}

/**
 * Encode SmartSelfieResult to a compact JSON string compatible with the JS event payload.
 * Matches iOS string-payload approach for parity.
 *
 * { "selfieFile": string, "livenessFiles": string[], "apiResponse"?: object }
 */
object SmartSelfieResultJson {
  fun encode(result: SmartSelfieResult): String {
    val obj = JSONObject()
    obj.put("selfieFile", result.selfieFile)
    val liveness = JSONArray()
    result.livenessFiles.forEach { liveness.put(it) }
    obj.put("livenessFiles", liveness)
    result.apiResponse?.let { api ->
      val apiObj = JSONObject()
      apiObj.put("code", api.code)
      apiObj.put("created_at", api.createdAt)
      apiObj.put("job_id", api.jobId)
      apiObj.put("job_type", api.jobType)
      apiObj.put("message", api.message)
      apiObj.put("partner_id", api.partnerId)
      apiObj.put("partner_params", api.partnerParams)
      apiObj.put("status", api.status)
      apiObj.put("updated_at", api.updatedAt)
      apiObj.put("user_id", api.userId)
      obj.put("apiResponse", apiObj)
    }
    return obj.toString()
  }
}

// Document Verification: success payload
fun DocumentVerificationResult.toWritableMap(): WritableMap = Arguments.createMap().apply {
  putString("selfie", selfieFile.toString())
  putString("documentFrontFile", documentFrontFile.toString())
  documentBackFile?.let { putString("documentBackFile", it.toString()) }
  putBoolean("didSubmitDocumentVerificationJob", didSubmitDocumentVerificationJob)
}

// Document Verification: error payload
fun Throwable.toDocumentVerificationErrorPayload(code: String? = null): WritableMap = Arguments.createMap().apply {
  putString("message", message ?: "Unknown error")
  code?.let { putString("code", it) }
}

// SmartSelfie: success payload (string JSON under key "result")
fun SmartSelfieResult.toWritableMap(): WritableMap = Arguments.createMap().apply {
  putString("result", SmartSelfieResultJson.encode(this@toWritableMap))
}

// SmartSelfie: error payload (string under key "error")
fun Throwable.toSmartSelfieErrorPayload(): WritableMap = Arguments.createMap().apply {
  putString("error", message ?: "Unknown error")
}
