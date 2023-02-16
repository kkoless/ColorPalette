//
//  ColorPaletteView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

struct ColorPaletteView: View {
    @StateObject var viewModel: ColorPaletteInfoViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State private var selectedType: ColorType
    @State private var showInfo: Bool
    @State private var isBlind: Bool
    @State private var blindPalette: ColorPalette
    
    let palette: ColorPalette
    
    private var invertedColor: Color {
        if !isBlind {
            return Color(palette.colors[0].uiColor.invertColor())
        } else {
            return Color(blindPalette.colors[0].uiColor.invertColor())
        }
    }
    
    init(viewModel: ColorPaletteInfoViewModel, palette: ColorPalette) {
        self.palette = palette
        self._viewModel = StateObject(wrappedValue: viewModel)
        self._selectedType = .init(initialValue: .HEX)
        self._showInfo = .init(initialValue: true)
        self._isBlind = .init(initialValue: false)
        self._blindPalette = .init(initialValue: palette)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            topBar
            
            VStack(spacing: 0) {
                ForEach(isBlind ? blindPalette.colors : palette.colors) { color in
                    ColorPaletteRowView(appColor: color, type: selectedType, showInfo: showInfo)
                }
            }
            .onTapGesture { showInfo.toggle() }
            .onAppear(perform: onAppear)
            
            ColorTypePickerView(selectedType: $selectedType)
                .padding(.top, 10)
        }
        .sheet(isPresented: $viewModel.output.showShareSheet,
               onDismiss: { viewModel.output.pdfURL = nil }) {
            if let url = viewModel.output.pdfURL {
                ShareSheet(urls: [url])
            }
        }
    }
}

private extension ColorPaletteView {
    var topBar: some View {
        ZStack {
            Color(isBlind ? blindPalette.colors[0] : palette.colors[0])
            HStack(spacing: 25) {
                backButton
                Spacer()
                blindButton
                shareButton
                favoriteButton
            }
            .padding(20)
        }
        .frame(height: 25)
        .padding([.top, .bottom])
    }
    
    var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "multiply")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(invertedColor)
        }
    }
    
    var favoriteButton: some View {
        Button(action: { changeFavoriteState() }, label: {
            Image(systemName: viewModel.output.isFavorite ? "heart.fill" : "heart")
                .resizable()
                .frame(width: 25, height: 25)
                .foregroundColor(viewModel.output.isFavorite ? .red : invertedColor)
        })
    }
    
    var shareButton: some View {
        Button(action: { shareTap() }, label: {
            Image(systemName: "square.and.arrow.up")
                .resizable()
                .frame(width: 20, height: 25)
                .foregroundColor(invertedColor)
        })
    }
    
    var blindButton: some View {
        Menu {
            ForEach(InclusiveColor.BlindnessType.allCases, id: \.rawValue) { type in
                Button(action: { blindTap(type) }) {
                    Text(type.title)
                }
            }
        } label: {
            Image(systemName: isBlind ? "eye.slash" : "eye")
                .resizable()
                .frame(width: 30, height: 20)
                .foregroundColor(invertedColor)
        }

    }
}

private extension ColorPaletteView {
    func onAppear() {
        viewModel.input.onAppear.send()
    }
    
    func changeFavoriteState() {
        viewModel.input.favTap.send()
    }
    
    func copyTap(_ appColor: AppColor, type: ColorType) {
        switch type {
            case .HEX:
                UIPasteboard.general.string = appColor.uiColor.hexValue
            case .RGB:
                UIPasteboard.general.string = appColor.uiColor.getRGBCopyInfo()
            case .HSB:
                UIPasteboard.general.string = appColor.uiColor.getHSBCopyInfo()
            case .CMYK:
                UIPasteboard.general.string = appColor.uiColor.getCMYKCopyInfo()
        }
    }
    
    func blindTap(_ type: InclusiveColor.BlindnessType) {
        blindPalette = ColorPalette(colors: palette.colors.map { AppColor(uiColor: $0.uiColor.inclusiveColor(for: type)) })
        
        isBlind = type != .normal ? true : false
    }
    
    func shareTap() {
        exportPDF(content: {
            ColorPalettePDFView(palette: palette, type: selectedType)
        }) { status, url in
            if let url = url, status {
                viewModel.output.pdfURL = url
                viewModel.output.showShareSheet.toggle()
            } else {
                print("Failed to produce PDF")
            }
        }
    }
}

struct ColorPaletteView_Previews: PreviewProvider {
    static var previews: some View {
        let palette = ColorPalette.getTestPalettes(20)[1]
        ColorPaletteView(viewModel: ColorPaletteInfoViewModel(palette: palette), palette: palette)
    }
}
