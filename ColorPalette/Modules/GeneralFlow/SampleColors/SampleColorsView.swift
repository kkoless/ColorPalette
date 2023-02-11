//
//  SampleColorsView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import SwiftUI

struct SampleColorsView: View {
    @StateObject var viewModel: SampleColorsViewModel
    @EnvironmentObject private var localizationService: LocalizationService
    
    @State private var searchText: String = ""
    @State private var selectedType: ColorType = .HEX
    
    var body: some View {
        VStack {
            navBar
            
            header
            
            SearchBarView(searchText: $searchText)
                .onChange(of: searchText, perform: { newValue in
                    viewModel.input.searchText.send(newValue)
                })
                .padding([.leading, .trailing])
            
            ColorTypePickerView(selectedType: $selectedType)
                .padding(.top, 10)
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    colorsBlock
                }
                .padding()
            }
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private extension SampleColorsView {
    var navBar: some View {
        CustomNavigationBarView(backAction: { viewModel.input.popTap.send() })
    }
    
    var header: some View {
        HStack {
            Text(.colors)
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    var colorsBlock: some View {
        ForEach(viewModel.output.colors) { appColor in
            ColorRowView(appColor: appColor, type: selectedType)
                .environmentObject(viewModel)
                .onTapGesture {
                    viewModel.input.colorTap.send(appColor)
                }
        }
    }
}

struct SampleColorsView_Previews: PreviewProvider {
    static var previews: some View {
        SampleColorsView(viewModel: SampleColorsViewModel())
            .environmentObject(LocalizationService.shared)
    }
}
