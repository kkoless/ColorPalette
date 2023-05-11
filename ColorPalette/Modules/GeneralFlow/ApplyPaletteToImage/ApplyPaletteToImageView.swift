//
//  ApplyPaletteToImageView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.04.2023.
//

import SwiftUI
import UIKit

struct ApplyPaletteToImageView: View {
    @StateObject var viewModel: ApplyPaletteToImageViewModel
    
    let palette: ColorPalette
    
    @State private var isSet: Bool = false
    @State private var selection: UIImage = .init()
    
    @State private var showPopover = false
    @State private var imageTap = (image: UIImage(), isShow: false)
    @State private var showSettingsAlert = false
    
    var body: some View {
        VStack(spacing: 0) {
            navBar
            
            Group {
                Text(.before).font(.headline)
                selectedImage
            }
            
            chooseButton
            
            palettePreview
            
            Group {
                Text(.after).font(.headline)
                resultImage
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .foregroundColor(.primary)
        .onChange(of: selection) { newValue in
            let jpegData = newValue
                .jpegData(compressionQuality: 1)
            viewModel.input.imageAppear.send(jpegData)
        }
        .sheet(isPresented: $imageTap.isShow, onDismiss: { imageTap.isShow = false }) {
            ImagePreviewerView(image: imageTap.image)
        }
    }
}

private extension ApplyPaletteToImageView {
    var navBar: some View {
        CustomNavigationBarView(backAction: { backTap() })
    }
    
    @ViewBuilder
    var selectedImage: some View {
        Group {
            if isSet {
                Image(uiImage: selection)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onTapGesture { imageTap = (image: selection, isShow: true) }
            } else { Color.gray }
        }
        .frame(width: 200, height: 200)
        .cornerRadius(15)
        .shadow(radius: 20)
        .padding()
    }
    
    @ViewBuilder
    var resultImage: some View {
        Group {
            if let imageData = viewModel.output.resultImageData, let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .onTapGesture { imageTap = (image: uiImage, isShow: true) }
            } else {
                ZStack {
                    Color.gray
                    if viewModel.output.showLoader {
                        ProgressView()
                    }
                }
            }
        }
        .frame(width: 200, height: 200)
        .cornerRadius(15)
        .shadow(radius: 20)
        .padding()
    }
    
    var chooseButton: some View {
        Button(action: { checkPermissions() }) {
            Text(.chooseImage)
        }
        .padding()
        .popover(isPresented: $showPopover) {
            ImagePicker(selectedImage: $selection, didSet: $isSet)
        }
        .alert(Text(.error), isPresented: $showSettingsAlert) {
            Button(action: { settingsTap() }) {
                Text(.settings)
            }
            Button(action: {}) {
                Text(.cancel)
            }
        } message: {
            Text(.cameraAccessDenied)
        }

    }
    
    var palettePreview: some View {
        ColorPaletteCell(palette: palette)
            .padding([.horizontal, .bottom])
    }
}

private extension ApplyPaletteToImageView {
    func checkPermissions() {
        PermissionsManager
            .checkPhotoLibraryPermission(
                deniedHandler: { showSettingsAlert.toggle() },
                authorizedHandler: { showPopover.toggle() }
            )
    }
    
    func settingsTap() {
        if let url = URL(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: { _ in
                // Handle
            })
        }
    }
    
    func backTap() {
        viewModel.input.backTap.send()
    }
}

struct ApplyPaletteToImageView_Previews: PreviewProvider {
    static var previews: some View {
        let palette: ColorPalette = .getRandomPalette(size: 4)
        ApplyPaletteToImageView(viewModel: ApplyPaletteToImageViewModel(palette: palette), palette: palette)
    }
}
