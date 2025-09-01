import UIKit
import React
import SwiftUI

@objc public class DocumentVerificationViewProvider: UIView {
  private var hostingController: UIHostingController<DocumentVerificationRootView>?
  @objc public var onSuccess: ((NSDictionary) -> Void)?
  @objc public var onError: ((NSString, NSString?) -> Void)?
  
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
