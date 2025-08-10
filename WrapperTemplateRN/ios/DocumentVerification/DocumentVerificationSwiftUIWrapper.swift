//
//  DocumentVerificationSwiftUIWrapper.swift
//  WrapperTemplateRN
//
//  Created by Harun Wangereka on 09/08/2025.
//

import SwiftUI
import UIKit

@objc public class DocumentVerificationSwiftUIWrapper: NSObject {
    
    private var hostingController: UIHostingController<DocumentVerificationSwiftUIView>?
    private var onButtonTapCallback: (() -> Void)?
    
    @objc public func createHostingController(onButtonTap: @escaping () -> Void) -> UIViewController {
        self.onButtonTapCallback = onButtonTap
        
        let swiftUIView = DocumentVerificationSwiftUIView(onButtonTap: onButtonTap)
        let hostingController = UIHostingController(rootView: swiftUIView)
        hostingController.view.backgroundColor = UIColor.clear
        
        self.hostingController = hostingController
        return hostingController
    }
    
    @objc public func getView() -> UIView? {
        return hostingController?.view
    }
}