import SwiftUI
import SmileID

struct SmartSelfieEnrollmentRootView: View, SmartSelfieResultDelegate {
  let onSuccess: (NSString) -> Void
  let onError: (NSString) -> Void

  init(
    onSuccess: @escaping (NSString) -> Void = { _ in },
    onError: @escaping (NSString) -> Void = { _ in }
  ) {
    self.onSuccess = onSuccess
    self.onError = onError
  }

  var body: some View {
    SmileID.smartSelfieEnrollmentScreen(userId: "userID", delegate: self)
  }

  func didSucceed(
    selfieImage: URL,
    livenessImages: [URL],
    apiResponse: SmartSelfieResponse?
  ) {
    var params: [String: Any] = [
              "selfieFile": selfieImage.absoluteString,
                "livenessFiles": livenessImages.map {
                    $0.absoluteString
                },
            ]
            if let apiResponse = apiResponse {
                params["apiResponse"] = apiResponse
            }

            guard let jsonData = try? JSONSerialization.data(withJSONObject: params.toJSONCompatibleDictionary(), options: .prettyPrinted) else {
              onError("Error converting to JSON")
                return
            }
    onSuccess(String(data: jsonData, encoding: .utf8)! as NSString)
  }

  func didError(error: Error) { onError(error.localizedDescription as NSString) }
}
