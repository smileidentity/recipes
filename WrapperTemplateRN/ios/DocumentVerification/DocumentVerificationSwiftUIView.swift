//
//  DocumentVerificationSwiftUIView.swift
//  WrapperTemplateRN
//
//  Created by Harun Wangereka on 09/08/2025.
//

import SwiftUI
import UIKit

struct DocumentVerificationSwiftUIView: View {
    @StateObject private var viewModel: DocumentVerificationViewModel
    let onButtonTap: () -> Void
    
    init(onButtonTap: @escaping () -> Void = {}) {
        self._viewModel = StateObject(wrappedValue: DocumentVerificationViewModel())
        self.onButtonTap = onButtonTap
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Spacer()
            
            // Icon
            Image(systemName: "doc.text.viewfinder")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            // Title
            Text(viewModel.title)
                .font(.title)
                .fontWeight(.bold)
                .multilineTextAlignment(.center)
                .foregroundColor(.primary)
            
            // Subtitle
            Text(viewModel.subtitle)
                .font(.title3)
                .fontWeight(.medium)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
            
            // Description
            Text(viewModel.description)
                .font(.body)
                .multilineTextAlignment(.center)
                .foregroundColor(.secondary)
                .padding(.horizontal)
            
            Spacer()
            
            // Action Button
            Button(action: {
                viewModel.handleButtonTap()
                onButtonTap()
            }) {
                HStack {
                    Image(systemName: "camera")
                    Text(viewModel.buttonTitle)
                }
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(10)
            }
            .padding(.horizontal)
            .padding(.bottom, 60)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(UIColor.systemBackground))
    }
}

#Preview {
    DocumentVerificationSwiftUIView()
}