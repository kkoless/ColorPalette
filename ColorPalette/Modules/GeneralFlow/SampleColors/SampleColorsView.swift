//
//  SampleColorsView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import SwiftUI

struct SampleColorsView: View {
    @State private var searchText: String = ""
    @State private var selectedType: ColorType = .HEX
    @Binding var showColorLibrary: Bool
    
    weak private var router: GeneralRoutable?
    
    @EnvironmentObject var templatePaletteManager: TemplatePaletteManager
    
    
    init(showColorLibrary: Binding<Bool>? = nil, router: GeneralRoutable? = nil) {
        self._showColorLibrary = showColorLibrary ?? .constant(false)
        self.router = router
    }
    
    var body: some View {
        VStack {
            navBar
            
            header
            
            SearchBarView(searchText: $searchText)
                .padding([.leading, .trailing])
            
            ColorTypePickerView(selectedType: $selectedType)
            
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
        CustomNavigationBarView(backAction: { pop() })
            .padding(.top, Consts.Constraints.top)
    }
    
    var header: some View {
        HStack {
            Text("Sample Colors")
                .font(.largeTitle)
                .bold()
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    var colorsBlock: some View {
        ForEach(getColors(searchText)) { appColor in
            ColorRowView(appColor: appColor, type: selectedType)
                .onTapGesture {
                    if showColorLibrary {
                        templatePaletteManager.addColor(appColor)
                        showColorLibrary.toggle()
                    }
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

private extension SampleColorsView {
    func pop() {
        router?.pop()
    }
}

struct SampleColorsView_Previews: PreviewProvider {
    static var previews: some View {
        SampleColorsView()
            .environmentObject(TemplatePaletteManager())
    }
}
