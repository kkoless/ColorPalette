//
//  ColorInfoView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import SwiftUI

struct ColorInfoView: View {
    @ObservedObject var viewModel: ColorInfoViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @Binding var isBlind: Bool
    @Binding var blindColor: AppColor
    
    let appColor: AppColor
    
    private var activeColor: AppColor {
        isBlind ? blindColor : appColor
    }
    
    private var invertedColor: Color {
         Color(activeColor.uiColor.invertColor()).opacity(1)
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Group {
                topBar
                ColorPreview(color: activeColor)
            }
            .background(Color(activeColor).opacity(activeColor.alpha))
        }
        .edgesIgnoringSafeArea(.bottom)
        .onAppear { viewModel.input.onAppear.send() }
        .sheet(isPresented: $viewModel.output.showShareSheet,
               onDismiss: { viewModel.output.pdfURL = nil }) {
            if let pdfUrl = viewModel.output.pdfURL {
                ShareSheet(urls: [pdfUrl])
            }
        }
    }
}

private extension ColorInfoView {
    var topBar: some View {
        HStack(spacing: 25) {
            backButton
            Spacer()
            blindButton
            copyButton
            shareButton
            favoriteButton
        }
        .padding([.top, .leading, .trailing], 20)
        .padding(.bottom, 15)
        .background(Color(activeColor).opacity(activeColor.alpha))
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
    
    var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "multiply")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(invertedColor)
        }
    }
    
    var copyButton: some View {
        Menu {
            Button(action: { copyColorInfo(.HEX) }, label: { Text("HEX") })
            Button(action: { copyColorInfo(.RGB) }, label: { Text("RGB") })
            Button(action: { copyColorInfo(.HSB) }, label: { Text("HSB") })
            Button(action: { copyColorInfo(.CMYK) }, label: { Text("CMYK") })
        } label: {
            Image(systemName: "clipboard")
                .resizable()
                .frame(width: 20, height: 25)
                .foregroundColor(invertedColor)
        }
    }
}

private extension ColorInfoView {
    func changeFavoriteState() {
        viewModel.input.favTap.send()
    }
    
    func shareTap() {
        exportPDF(content: {
            ColorPreview(color: appColor)
        }) { status, url in
            if let url = url, status {
                viewModel.output.pdfURL = url
                viewModel.output.showShareSheet.toggle()
            } else {
                print("Failed to produce PDF")
            }
        }
    }
    
    func blindTap(_ type: InclusiveColor.BlindnessType) {
        blindColor = AppColor(uiColor: appColor.uiColor.inclusiveColor(for: type))
        isBlind = type != .normal ? true : false
    }
    
    func copyColorInfo(_ type: ColorType) {
        let color = isBlind ? blindColor : appColor
        switch type {
            case .HEX:
                UIPasteboard.general.string = color.uiColor.hexValue
            case .RGB:
                UIPasteboard.general.string = color.uiColor.getRGBCopyInfo()
            case .HSB:
                UIPasteboard.general.string = color.uiColor.getHSBCopyInfo()
            case .CMYK:
                UIPasteboard.general.string = color.uiColor.getCMYKCopyInfo()
        }
    }
}

struct ColorInfoView_Previews: PreviewProvider {
    static var previews: some View {
        let appColor = AppColor(name: "African Violet", hex: "#B284BE", alpha: 0.95)
        ColorInfoView(
            viewModel: ColorInfoViewModel(color: appColor),
            isBlind: .constant(false),
            blindColor: .constant(appColor),
            appColor: appColor
        )
    }
}
