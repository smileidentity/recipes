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

  func didError(error: Error) {
    onError(error.localizedDescription as NSString)
  }
}


extension Dictionary where Key == String, Value == Any {
  func toJSONCompatibleDictionary() -> [String: Any] {
    var jsonCompatibleDict = [String: Any]()
    for (key, value) in self {
      if let arrayValue = value as? [Any] {
        jsonCompatibleDict[key] = arrayValue.map { convertToJSONCompatible($0) }
      } else {
        jsonCompatibleDict[key] = convertToJSONCompatible(value)
      }
    }
    return jsonCompatibleDict
  }
}
  
  private func convertToJSONCompatible(_ value: Any) -> Any {
    switch value {
    case let url as URL:
      return url.absoluteString
    case let bool as Bool:
      return bool
    case let string as String:
      return string
    case let number as NSNumber:
      return number
    case let dict as [String: Any]:
      return dict.toJSONCompatibleDictionary()
    default:
      return String(describing: value)
    }
  }

