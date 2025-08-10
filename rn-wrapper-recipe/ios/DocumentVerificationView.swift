import SwiftUI
import SmileID

struct DocumentVerificationView: View, DocumentVerificationResultDelegate {
    var body: some View {
      SmileID.documentVerificationScreen(
        countryCode: "KE",
        delegate: self
      )
    }
  
  func didSucceed(selfie: URL,documentFrontImage: URL,documentBackImage: URL?,didSubmitDocumentVerificationJob: Bool) {
      var params: [String: Any] = [
          "selfie": selfie.absoluteString,
          "documentFrontFile": documentFrontImage.absoluteString,
          "didSubmitDocumentVerificationJob": didSubmitDocumentVerificationJob,
      ]
      if let documentBackImage {
          params["documentBackFile"] = documentBackImage.absoluteString
      }
    print("Successfully submitted Document Verification job")
  }

  func didError(error: Error) {
    print("An error occurred - \(error.localizedDescription)")
  }
}
