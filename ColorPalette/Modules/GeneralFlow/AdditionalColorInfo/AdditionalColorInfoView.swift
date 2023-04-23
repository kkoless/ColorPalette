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
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                Text(color.name.capitalized).font(.headline)
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
            backAction: { viewModel.input.backTap.send() }
        )
    }
    
    var content: some View {
        ScrollView {
            similarsColors
            
            if !viewModel.output.imageUrls.isEmpty {
                images
            }
            
            SimilarColorsView(color: color.uiColor)
        }
    }
    
    var similarsColors: some View {
        VStack {
            HStack {
                Text(.similarColors).font(.headline)
                Spacer()
            }
            
            HStack(spacing: 15) {
                ForEach(Array(color.uiColor.getSimilarColors(threshold: 0.1).prefix(4))) { color in
                    Color(uiColor: color)
                        .frame(width: 60, height: 60)
                        .cornerRadius(10)
                        .shadow(radius: 5)
                }
            }
        }
        .padding(.horizontal)
        .padding(.bottom, 15)
    }
    
    var images: some View {
        VStack {
            HStack {
                Text(.images).font(.headline)
                Spacer()
            }
            
            LazyVGrid(columns: [
                GridItem(.fixed(110), spacing: 15),
                GridItem(.fixed(110), spacing: 15),
                GridItem(.fixed(110), spacing: 15)
            ], alignment: .center) {
                Group {
                    ForEach(viewModel.output.imageUrls) { url in
                        AsyncImage(url: url)
                            .frame(width: 110, height: 110)
                            .cornerRadius(10)
                            .shadow(radius: 10)
                    }
                }
            }
        }
        .padding(.horizontal)
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
