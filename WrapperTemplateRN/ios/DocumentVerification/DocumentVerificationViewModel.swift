//
//  DocumentVerificationViewModel.swift
//  WrapperTemplateRN
//
//  Created by Harun Wangereka on 09/08/2025.
//

import Foundation
import Combine

class DocumentVerificationViewModel: ObservableObject {
    @Published var title: String = "Document Verification"
    @Published var subtitle: String = "Native SwiftUI View"
    @Published var description: String = "This is a native SwiftUI component rendered inside React Native using Fabric."
    @Published var buttonTitle: String = "Start Verification"
    
    init() {}
    
    func updateTitle(_ newTitle: String) {
        title = newTitle
    }
    
    func updateSubtitle(_ newSubtitle: String) {
        subtitle = newSubtitle
    }
    
    func updateDescription(_ newDescription: String) {
        description = newDescription
    }
    
    func updateButtonTitle(_ newButtonTitle: String) {
        buttonTitle = newButtonTitle
    }
    
    func handleButtonTap() {
        print("Document verification button tapped from SwiftUI!")
    }
}