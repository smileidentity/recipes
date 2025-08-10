import SwiftUI
import SmileID

struct SmartSelfieAuthenticationRootView: View, SmartSelfieResultDelegate {
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
    SmileID.smartSelfieAuthenticationScreen(userId: "userID", delegate: self)
  }

  func didSucceed(
    selfieImage: URL,
    livenessImages: [URL],
    apiResponse: SmartSelfieResponse?
  ) {
    var params: [String: Any] = [
      "selfieFile": selfieImage.absoluteString,
      "livenessFiles": livenessImages.map { $0.absoluteString },
    ]
    let api: [String: Any] = [
      "code": apiResponse?.code as Any,
      "created_at": apiResponse?.createdAt as Any,
      "job_id": apiResponse?.jobId as Any,
      "job_type": apiResponse?.jobType as Any,
      "message": apiResponse?.message as Any,
      "partner_id": apiResponse?.partnerId as Any,
      "partner_params": apiResponse?.partnerParams as Any,
      "status": apiResponse?.status as Any,
      "updated_at": apiResponse?.updatedAt as Any,
      "user_id": apiResponse?.userId as Any,
    ]
    params["apiResponse"] = api
    guard let jsonData = try? JSONSerialization.data(withJSONObject: params, options: []) else {
      onError("SmartSelfie JSON encoding error")
      return
    }
    let json = String(data: jsonData, encoding: .utf8) ?? "{}"
    onSuccess(json as NSString)
  }

  func didError(error: Error) {
    onError(error.localizedDescription as NSString)
  }
}
