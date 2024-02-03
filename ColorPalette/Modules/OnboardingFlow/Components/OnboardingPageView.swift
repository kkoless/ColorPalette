//
//  OnboardingPageView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import SwiftUI
import Combine

struct OnboardingPageView: View {
  @ObservedObject var viewModel: OnboardingViewModel
  
  let pageType: OnboardingPageType
  
  var body: some View {
    VStack {
      mainImage
      textView
    }
    .padding()
  }
}

private extension OnboardingPageView {
  private var mainImage: some View {
    Image(uiImage: pageType.image)
      .resizable()
      .frame(width: 250, height: 250)
      .padding(.bottom, 20)
  }
  
  private var textView: some View {
    Text(pageType.text)
      .multilineTextAlignment(.center)
      .font(.headline)
  }
}

struct OnboardingPageView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingPageView(viewModel: OnboardingViewModel(),
                       pageType: .firstPage)
  }
}
