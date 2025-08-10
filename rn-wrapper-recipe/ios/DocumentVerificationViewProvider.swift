import UIKit
import React
import SwiftUI

@objc public class DocumentVerificationViewProvider: UIView {
  private var hostingController: UIHostingController<DocumentVerificationView>?
  
  public override func layoutSubviews() {
       super.layoutSubviews()
       setupView()
     }
   
   private func setupView() {
     if self.hostingController != nil {
       return
     }
     
     self.hostingController = UIHostingController(
       rootView: DocumentVerificationView()
     )
     
     if let hostingController = self.hostingController {
       addSubview(hostingController.view)
       hostingController.view.translatesAutoresizingMaskIntoConstraints = false
       hostingController.view.pinEdges(to: self)
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
