//
//  ColorInfoPagesView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.04.2023.
//

import SwiftUI

struct ColorInfoPagesView: View {
  @StateObject var colorInfoViewModel: ColorInfoViewModel
  @StateObject var additionalColorInfoViewModel: AdditionalColorInfoViewModel

  @State private var isBlind: Bool = false
  @State private var blindColor: AppColor = .getClear()
  @State private var currentTab = 0

  let appColor: AppColor

  private var activeColor: AppColor {
    isBlind ? blindColor : appColor
  }

  var body: some View {
    TabView(selection: $currentTab) {
      ColorInfoView(
        viewModel: colorInfoViewModel,
        isBlind: $isBlind,
        blindColor: $blindColor,
        appColor: activeColor
      )
      .tag(0)

      AdditionalColorInfoView(
        viewModel: additionalColorInfoViewModel,
        color: activeColor
      )
      .tag(1)
    }
    .background(Color(activeColor))
    .onChange(of: currentTab, perform: { newValue in
      if newValue == 1 {
        withAnimation {
          isBlind = false
        }
      }
    })
    .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
    .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
  }
}

struct ColorInfoPagesView_Previews: PreviewProvider {
  static var previews: some View {
    let appColor: AppColor = .getRandomColor()
    ColorInfoPagesView(
      colorInfoViewModel: ColorInfoViewModel(color: appColor),
      additionalColorInfoViewModel: AdditionalColorInfoViewModel(color: appColor),
      appColor: appColor
    )
  }
}
