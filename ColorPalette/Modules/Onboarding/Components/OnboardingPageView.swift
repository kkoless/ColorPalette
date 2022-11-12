//
//  OnboardingPageView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import SwiftUI
import Combine

struct OnboardingPageView: View {
    let model: OnboardingPage
    
    var body: some View {
        VStack {
            Spacer()
            mainImage
            Spacer()
            Text(model.pageType.text)
            Spacer()
            nextButton
        }
        .frame(maxWidth: .infinity)
        .foregroundColor(Color(model.pageType.foregroundColor))
    }
    
}

private extension OnboardingPageView {
    @ViewBuilder var mainImage: some View {
        if let image = model.pageType.image {
            Image(uiImage: image)
        }
    }
    
    @ViewBuilder var nextButton: some View {
        if model.pageType.isLastPage {
            Button("Next") { model.tap.send() }
            Spacer()
        }
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(
            model: OnboardingPage(pageType: .thirdPage, tap: PassthroughSubject<Void, Never>())
        )
    }
}
