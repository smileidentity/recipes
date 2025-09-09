import UIKit
import React
import SwiftUI

@objc public class DocumentVerificationViewProvider: UIView {
  private var hostingController: UIHostingController<DocumentVerificationRootView>?
  @objc public var onSuccess: ((NSDictionary) -> Void)?
  @objc public var onError: ((NSString, NSString?) -> Void)?

  // Params mirrored from React props
  @objc public var countryCode: NSString = ""
  @objc public var userId: NSString? = nil
  @objc public var jobId: NSString? = nil
  @objc public var documentType: NSString? = nil
  @objc public var captureBothSides: NSNumber = true
  @objc public var idAspectRatio: NSNumber? = nil
  @objc public var bypassSelfieCaptureWithFile: NSString? = nil
  @objc public var autoCaptureTimeout: NSNumber = 10
  @objc public var autoCapture: NSString? = nil
  @objc public var allowNewEnroll: NSNumber = false
  @objc public var allowAgentMode: NSNumber = false
  @objc public var allowGalleryUpload: NSNumber = false
  @objc public var showInstructions: NSNumber = true
  @objc public var showAttribution: NSNumber = true
  @objc public var skipApiSubmission: NSNumber = false
  @objc public var useStrictMode: NSNumber = false
  @objc public var extraPartnerParams: NSArray? = nil

  public override func layoutSubviews() {
       super.layoutSubviews()
       setupView()
     }

   private func setupView() {
     if self.hostingController != nil {
       return
     }

     self.hostingController = UIHostingController(
       rootView: DocumentVerificationRootView(
         params: buildParams(),
         onSuccess: { [weak self] payload in
           self?.onSuccess?(payload)
         },
         onError: { [weak self] message, code in
           self?.onError?(message as NSString, code as NSString?)
         }
       )
     )

     if let hostingController = self.hostingController {
       addSubview(hostingController.view)
       hostingController.view.translatesAutoresizingMaskIntoConstraints = false
       hostingController.view.pinEdges(to: self)
       hostingController.view.overrideUserInterfaceStyle = .light
       reactAddController(toClosestParent: hostingController)
     }
   }
  private func buildParams() -> DocumentVerificationParams {
    var documentVerificationParams = DocumentVerificationParams()
    documentVerificationParams.countryCode = countryCode as String
    documentVerificationParams.userId = userId as String?
    documentVerificationParams.jobId = jobId as String?
    documentVerificationParams.documentType = documentType as String?
    documentVerificationParams.captureBothSides = captureBothSides.boolValue
    if let ratio = idAspectRatio?.doubleValue { documentVerificationParams.idAspectRatio = ratio }
    documentVerificationParams.bypassSelfieCaptureWithFile = bypassSelfieCaptureWithFile as String?
    documentVerificationParams.autoCaptureTimeout = autoCaptureTimeout.intValue
    documentVerificationParams.autoCapture = autoCapture as String?
    documentVerificationParams.allowNewEnroll = allowNewEnroll.boolValue
    documentVerificationParams.allowAgentMode = allowAgentMode.boolValue
    documentVerificationParams.allowGalleryUpload = allowGalleryUpload.boolValue
    documentVerificationParams.showInstructions = showInstructions.boolValue
    documentVerificationParams.showAttribution = showAttribution.boolValue
    documentVerificationParams.skipApiSubmission = skipApiSubmission.boolValue
    documentVerificationParams.useStrictMode = useStrictMode.boolValue
    if let arr = extraPartnerParams as? [[String: String]] {
      var map: [String: String] = [:]
      for entry in arr { if let k = entry["key"], let v = entry["value"] { map[k] = v } }
      documentVerificationParams.extraPartnerParams = map
    }
    return documentVerificationParams
  }
  // Rebuild the SwiftUI root view when any prop changes
  @objc public func updateParams() {
    guard let hostingController = hostingController else { return }
    hostingController.rootView = DocumentVerificationRootView(
      params: buildParams(),
      onSuccess: { [weak self] payload in
        self?.onSuccess?(payload)
      },
      onError: { [weak self] message, code in
        self?.onError?(message as NSString, code as NSString?)
      }
    )
  }
}

 extension UIView {
   func pinEdges(to other: UIView) {
     NSLayoutConstraint.activate([
       leadingAnchor.constraint(equalTo: other.leadingAnchor),
       trailingAnchor.constraint(equalTo: other.trailingAnchor),
       topAnchor.constraint(equalTo: other.topAnchor),
       bottomAnchor.constraint(equalTo: other.bottomAnchor)
     ])
   }
}
