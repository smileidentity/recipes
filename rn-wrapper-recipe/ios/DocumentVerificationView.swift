import SwiftUI
import SmileID

struct DocumentVerificationRootView: View, DocumentVerificationResultDelegate {
  let onSuccess: (NSDictionary) -> Void
  let onError: (String, String?) -> Void

  init(
    onSuccess: @escaping (NSDictionary) -> Void = { _ in },
    onError: @escaping (String, String?) -> Void = { _, _ in }
  ) {
    self.onSuccess = onSuccess
    self.onError = onError
  }

  var body: some View {
    SmileID.documentVerificationScreen(
      countryCode: "KE",
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
