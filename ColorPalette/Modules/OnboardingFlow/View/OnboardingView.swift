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

    var body: some View {
        TabView(selection: $currentTab) {
            pages
        }
        .tabViewStyle(PageTabViewStyle())
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .always))
    }
}

private extension OnboardingView {
    @ViewBuilder var pages: some View {
        ForEach(OnboardingPageType.allCases) { pageType in
            OnboardingPageView(pageType: pageType)
                .environmentObject(viewModel)
                .tag(pageType.id)
        }
    }
}

struct OnboardingView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingView(viewModel: OnboardingViewModel())
    }
}
