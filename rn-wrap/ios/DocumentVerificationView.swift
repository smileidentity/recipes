import SwiftUI
import SmileID

// Struct representing the full prop set coming from JS
struct DocumentVerificationParams: Equatable {
  var countryCode: String = ""
  var userId: String? = nil
  var jobId: String? = nil
  var documentType: String? = nil
  var captureBothSides: Bool = true
  var idAspectRatio: Double? = nil
  var bypassSelfieCaptureWithFile: String? = nil
  var autoCaptureTimeout: Int = 10
  var autoCapture: String? = nil
  var allowNewEnroll: Bool = false
  var allowAgentMode: Bool = false
  var allowGalleryUpload: Bool = false
  var showInstructions: Bool = true
  var showAttribution: Bool = true
  var skipApiSubmission: Bool = false
  var useStrictMode: Bool = false
  var extraPartnerParams: [String: String] = [:]
}

struct DocumentVerificationRootView: View, DocumentVerificationResultDelegate {
  let params: DocumentVerificationParams
  let onSuccess: (NSDictionary) -> Void
  let onError: (String, String?) -> Void

  init(
    params: DocumentVerificationParams,
    onSuccess: @escaping (NSDictionary) -> Void = { _ in },
    onError: @escaping (String, String?) -> Void = { _, _ in }
  ) {
    self.params = params
    self.onSuccess = onSuccess
    self.onError = onError
  }

  var body: some View {
    SmileID.documentVerificationScreen(
      userId: params.userId ?? generateUserId(),
      jobId: params.jobId ?? generateJobId(),
      allowNewEnroll: params.allowNewEnroll,
      countryCode: params.countryCode,
      documentType: params.documentType,
      idAspectRatio: params.idAspectRatio,
      bypassSelfieCaptureWithFile: params.bypassSelfieCaptureWithFile.flatMap(URL.init),
      autoCaptureTimeout: TimeInterval(params.autoCaptureTimeout),
      autoCapture: AutoCapture(from: params.autoCapture),
      captureBothSides: params.captureBothSides,
      allowAgentMode: params.allowAgentMode,
      allowGalleryUpload: params.allowGalleryUpload,
      showInstructions: params.showInstructions,
      showAttribution: params.showAttribution,
      skipApiSubmission: params.skipApiSubmission,
      useStrictMode: params.useStrictMode,
      extraPartnerParams: params.extraPartnerParams,
      delegate: self
    )
  }

  func didSucceed(
    selfie: URL,
    documentFrontImage: URL,
    documentBackImage: URL?,
    didSubmitDocumentVerificationJob: Bool
  ) {
    let payload: NSMutableDictionary = [
      "selfie": selfie.absoluteString,
      "documentFrontFile": documentFrontImage.absoluteString,
      "didSubmitDocumentVerificationJob": didSubmitDocumentVerificationJob,
    ]
    if let documentBackImage {
      payload["documentBackFile"] = documentBackImage.absoluteString
    }
    onSuccess(payload)
  }

  func didError(error: Error) {
    onError(error.localizedDescription, nil)
  }
}

private extension AutoCapture {
  init(from raw: String?) {
    switch raw {
    case "AutoCaptureOnly": self = .autoCaptureOnly
    case "ManualCaptureOnly": self = .manualCaptureOnly
    case .some("AutoCapture"): self = .autoCapture
    default: self = .autoCapture
    }
  }
}
