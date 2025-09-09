import UIKit
import React
import SwiftUI

@objc public class DocumentVerificationViewProvider: UIView {
  private var hostingController: UIHostingController<DocumentVerificationRootView>?
  @objc public var onSuccess: ((NSDictionary) -> Void)?
  @objc public var onError: ((NSString, NSString?) -> Void)?

  // Params mirrored from React props
  @objc public var countryCode: NSString = "KE"
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
    var p = DocumentVerificationParams()
    p.countryCode = countryCode as String
    p.userId = userId as String?
    p.jobId = jobId as String?
    p.documentType = documentType as String?
    p.captureBothSides = captureBothSides.boolValue
    if let ratio = idAspectRatio?.doubleValue { p.idAspectRatio = ratio }
    p.bypassSelfieCaptureWithFile = bypassSelfieCaptureWithFile as String?
    p.autoCaptureTimeout = autoCaptureTimeout.intValue
    p.autoCapture = autoCapture as String?
    p.allowNewEnroll = allowNewEnroll.boolValue
    p.allowAgentMode = allowAgentMode.boolValue
    p.allowGalleryUpload = allowGalleryUpload.boolValue
    p.showInstructions = showInstructions.boolValue
    p.showAttribution = showAttribution.boolValue
    p.skipApiSubmission = skipApiSubmission.boolValue
    p.useStrictMode = useStrictMode.boolValue
    if let arr = extraPartnerParams as? [[String: String]] {
      var map: [String: String] = [:]
      for entry in arr { if let k = entry["key"], let v = entry["value"] { map[k] = v } }
      p.extraPartnerParams = map
    }
    return p
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
