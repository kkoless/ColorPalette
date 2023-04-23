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
    
    @State private var currentTab = 0
    
    let appColor: AppColor
    
    var body: some View {
        TabView(selection: $currentTab) {
            ColorInfoView(viewModel: colorInfoViewModel, appColor: appColor)
                .tag(0)
            
            AdditionalColorInfoView(viewModel: additionalColorInfoViewModel, color: appColor)
                .tag(1)
        }
        .background(Color(appColor))
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .always))
        .indexViewStyle(PageIndexViewStyle(backgroundDisplayMode: .never))
    }
}

struct ColorInfoPagesView_Previews: PreviewProvider {
    static var previews: some View {
        let appColor: AppColor = .getRandomColor()
        ColorInfoPagesView(colorInfoViewModel: ColorInfoViewModel(color: appColor), additionalColorInfoViewModel: AdditionalColorInfoViewModel(color: appColor), appColor: appColor)
    }
}
