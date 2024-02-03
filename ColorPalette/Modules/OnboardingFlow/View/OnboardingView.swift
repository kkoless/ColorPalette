//
//  OnboardingView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.11.2022.
//

import SwiftUI
import Combine

struct OnboardingView: View {
  @StateObject var viewModel: OnboardingViewModel
  @State private var currentTab = 0
  
  private var backgroundColor: Color {
    Color(uiColor: OnboardingPageType(rawValue: currentTab)!.backgroundColor)
  }
  
  private var foregroundColor: Color {
    Color(uiColor: OnboardingPageType(rawValue: currentTab)!.foregroundColor)
  }
  
  private var isLast: Bool {
    OnboardingPageType(rawValue: currentTab)!.isLastPage
  }
  
  var body: some View {
    ZStack {
      TabView(selection: $currentTab) { pages }
      buttonsView
    }
    .background(backgroundColor)
    .foregroundColor(foregroundColor)
    .tabViewStyle(PageTabViewStyle())
    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
  }
}

private extension OnboardingView {
  @ViewBuilder 
  private var pages: some View {
    ForEach(OnboardingPageType.allCases) { pageType in
      OnboardingPageView(viewModel: viewModel,
                         pageType: pageType)
      .tag(pageType.id)
    }
  }
  
  @ViewBuilder
  private var buttonsView: some View {
    VStack(spacing: 0) {
      Spacer()
      
      HStack {
        if !isLast {
          Button(action: { skipTap() }) {
            Text(.skip).font(.subheadline.bold())
          }
          .padding(.leading)
        } else { Spacer() }
        
        Spacer()
        Spacer()
        Spacer()
        Spacer()
        
        Button(action: { nextTap() }) {
          Text(.next).font(.subheadline.bold())
        }
        .padding(.trailing)
      }
    }
    .padding()
  }
}

private extension OnboardingView {
  private func nextTap() {
    if !isLast { withAnimation { currentTab += 1 } }
    else { viewModel.input.skipTap.send() }
  }
  
  private func skipTap() {
    viewModel.input.skipTap.send()
  }
}

struct OnboardingView_Previews: PreviewProvider {
  static var previews: some View {
    OnboardingView(viewModel: OnboardingViewModel())
  }
}
