//
//  ImageColorDetectionView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

struct ImageColorDetectionView: View {
    @State private var isSet: Bool = false
    @State private var selection: UIImage = .init()
    @State private var showPopover = false
    @State private var showSettingsAlert = false
    @State private var avarageColorOfImage: Color = {
        .systemCustomBackground
    }()
    
    private var foregroundColor: Color {
        if avarageColorOfImage == .systemCustomBackground {
            return .invertedSystemCustomBackground
        } else {
            return Color(uiColor: avarageColorOfImage.uiColor.invertColor())
        }
    }
    private var isAddDisabled: Bool {
        viewModel.output.isLimit || viewModel.output.isFavorire
    }
    
    @ObservedObject var viewModel: ImageColorDetectionViewModel
    
    var body: some View {
        VStack {
            navBar
            
            selectedImage
                .frame(width: 250, height: 250)
                .cornerRadius(15)
                .shadow(radius: 20)
                .padding()
            
            chooseButton
        
            if viewModel.output.palette != nil {
                palette
            }
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
        .background(avarageColorOfImage)
        .foregroundColor(foregroundColor)
        .onChange(of: selection) { newValue in
            let jpegData = newValue
                .jpegData(compressionQuality: 1)
            viewModel.input.imageAppear.send(jpegData)
            if let uiColor = newValue.averageColor {
                avarageColorOfImage = Color(uiColor: uiColor)
            }
        }
    }
}

private extension ImageColorDetectionView {
    var navBar: some View {
        CustomNavigationBarView(backAction: { viewModel.input.backTap.send() } )
            .trailingItems {
                if viewModel.output.palette != nil {
                    Button(action: { addToFavorite() }) {
                        Image(systemName: "plus.circle")
                            .resizable()
                            .frame(width: 25, height: 25)
                    }
                    .disabled(isAddDisabled)
                    .foregroundColor(isAddDisabled ? .gray : foregroundColor)
                }
            }
    }
    
    @ViewBuilder
    var selectedImage: some View {
        if isSet {
            Image(uiImage: selection)
                .resizable()
                .aspectRatio(contentMode: .fill)
                
        } else { Color.gray }
    }
    
    @ViewBuilder
    var palette: some View {
        if let palette = viewModel.output.palette {
            ColorPaletteCell(palette: palette)
                .padding()
                .onTapGesture {
                    viewModel.input.showPaletteTap.send(palette)
                }
                .shadow(radius: 20)
        }
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
    
    var addToFavoriteButton: some View {
        Button(action: { addToFavorite() }) {
            Text(.addPalette)
        }
        .padding()
        .disabled(viewModel.output.isLimit)
    }
}

private extension ImageColorDetectionView {
    func addToFavorite() {
        if let palette = viewModel.output.palette {
            viewModel.input.addToFavoriteTap.send(palette)
        }
    }
    
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
}


struct ImageColorDetectionView_Previews: PreviewProvider {
    static var previews: some View {
        ImageColorDetectionView(viewModel: ImageColorDetectionViewModel())
            .environmentObject(LocalizationService.shared)
    }
}
