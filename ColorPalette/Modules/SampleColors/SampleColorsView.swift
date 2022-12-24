//
//  SampleColorsView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import SwiftUI

struct SampleColorsView: View {
    @State var searchText: String = ""
    @State var selectedType: ColorType = .RGB
    
    weak var router: GeneralRoutable?
    
    var body: some View {
        VStack {
            header
            
            SearchBarView(searchText: $searchText)
                .padding()
            
            ColorTypePickerView(selectedType: $selectedType)
            
            ScrollView {
                LazyVStack(spacing: 15) {
                    colorsBlock
                }
                .padding()
            }
        }
    }
}

private extension SampleColorsView {
    var header: some View {
        HStack {
            Text("Sample Colors")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding()
    }
    
    var colorsBlock: some View {
        ForEach(getColors(searchText)) { appColor in
            ColorInfoView(appColor: appColor, type: selectedType)
                .onTapGesture {
                    router?.showSimilarColors(color: appColor)
                }
        }
    }
}

private extension SampleColorsView {
    func getColors(_ searchText: String) -> [AppColor] {
        let colors = ColorManager.shared.colors
        
        if searchText.isEmpty {
            return colors
        } else {
            return colors
                .filter { $0.name.contains(searchText) }
        }
    }
}

struct SampleColorsView_Previews: PreviewProvider {
    static var previews: some View {
        SampleColorsView()
    }
}
