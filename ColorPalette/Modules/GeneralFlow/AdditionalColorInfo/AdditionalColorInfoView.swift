//
//  AdditionalColorInfoView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.04.2023.
//

import SwiftUI

struct AdditionalColorInfoView: View {
    @StateObject var viewModel: AdditionalColorInfoViewModel
    
    let color: AppColor
    
    private var colorName: String {
        color.name.localized().capitalized
    }
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(color.name.capitalized)
                    .font(.title2.bold())
            }
            .padding(.top, 25)
            
            content
        }
        .background(Color(color))
        .foregroundColor(Color(uiColor: color.uiColor.invertColor()))
        .onAppear(perform: onAppear)
    }
}

private extension AdditionalColorInfoView {
    var navBar: some View {
        CustomNavigationBarView(
            backAction: { viewModel.input.backTap.send() },
            titleText: colorName
        )
    }
    
    var content: some View {
        ScrollView {
            LazyVGrid(columns: [
                GridItem(.fixed(130), spacing: 50),
                GridItem(.fixed(130), spacing: 50)
            ], alignment: .center) {
                Group {
                    ForEach(viewModel.output.imageUrls) { url in
                        AsyncImage(url: url)
                            .frame(width: 130, height: 130)
                            .cornerRadius(10)
                            .padding(.top, 20)
                    }
                }
            }
            
            SimilarColorsView(color: color.uiColor)
        }
    }
}

private extension AdditionalColorInfoView {
    func onAppear() {
        viewModel.input.onAppear.send()
    }
}

struct AdditionalColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        AdditionalColorInfoView(viewModel: AdditionalColorInfoViewModel(color: .getRandomColor()), color: .getRandomColor())
    }
}
