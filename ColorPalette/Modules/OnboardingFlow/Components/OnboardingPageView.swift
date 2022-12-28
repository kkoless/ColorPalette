//
//  OnboardingPageView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import SwiftUI
import Combine

struct OnboardingPageView: View {
    @EnvironmentObject var viewModel: OnboardingViewModel
    let pageType: OnboardingPageType
    
    var body: some View {
        VStack {
            Spacer()
            mainImage
            Spacer()
            Text(pageType.text)
            Spacer()
            buttons
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(Color(pageType.foregroundColor))
    }
    
}

private extension OnboardingPageView {
    @ViewBuilder var mainImage: some View {
        if let image = pageType.image {
            Image(uiImage: image)
                .padding()
        }
    }
    
    @ViewBuilder var buttons: some View {
        if pageType.isLastPage {
            VStack(spacing: 30) {
                Button(action: { signInTap() }) {
                    Text("Sign In")
                }
                
                Button(action: { skipTap() }) {
                    Text("Next")
                }
            }
            .padding()
        }
    }
}

private extension OnboardingPageView {
    func signInTap() {
        viewModel.input.signInTap.send()
    }
    
    func skipTap() {
        viewModel.input.skipTap.send()
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(pageType: .thirdPage)
            .environmentObject(OnboardingViewModel())
    }
}
