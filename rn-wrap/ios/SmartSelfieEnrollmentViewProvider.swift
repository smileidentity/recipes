import UIKit
import React
import SwiftUI
import SmileID

@objc public class SmartSelfieEnrollmentViewProvider: UIView {
  private var hostingController: UIHostingController<SmartSelfieEnrollmentRootView>?
  @objc public var onSuccess: ((NSString) -> Void)?
  @objc public var onError: ((NSString) -> Void)?

  public override func layoutSubviews() {
    super.layoutSubviews()
    setupView()
  }

  private func setupView() {
    if self.hostingController != nil { return }
    self.hostingController = UIHostingController(
      rootView: SmartSelfieEnrollmentRootView(
        onSuccess: { [weak self] json in self?.onSuccess?(json) },
        onError: { [weak self] json in self?.onError?(json) }
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
}
