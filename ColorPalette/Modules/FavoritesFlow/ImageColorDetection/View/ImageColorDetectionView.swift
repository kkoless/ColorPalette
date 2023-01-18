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
                addToFavoriteButton
                Spacer()
            } else {
                Spacer()
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onChange(of: selection) { newValue in
            let jpegData = newValue
                .jpegData(compressionQuality: 1)
            viewModel.input.imageAppear.send(jpegData)
        }
    }
}

private extension ImageColorDetectionView {
    var navBar: some View {
        CustomNavigationBarView()
            .padding(.top, Consts.Constraints.top)
    }
    
    @ViewBuilder
    var selectedImage: some View {
        if isSet {
            Image(uiImage: selection)
                .resizable()
                .aspectRatio(contentMode: .fill)
                
        } else {
            Color.gray
        }
    }
    
    @ViewBuilder
    var palette: some View {
        if let palette = viewModel.output.palette {
            ColorPaletteCell(palette: palette)
                .padding([.leading, .trailing])
                .onTapGesture {
                    viewModel.input.showPaletteTap.send(palette)
                }
        }
    }
    
    var chooseButton: some View {
        Button(action: {
            PermissionsManager
                .checkPhotoLibraryPermission(
                    deniedHandler: { showSettingsAlert.toggle() },
                    authorizedHandler: { showPopover.toggle() }
                )
        }) {
            Text("Choose image")
        }
        .padding()
        .popover(isPresented: $showPopover) {
            ImagePicker(selectedImage: $selection, didSet: $isSet)
        }
        .alert(Text("Error"), isPresented: $showSettingsAlert) {
            Button(action: { settingsTap() }) {
                Text("Settings")
            }
            Button(action: {}) {
                Text("Cancel")
            }
        } message: {
            Text("Camera access is denied")
        }

    }
    
    var addToFavoriteButton: some View {
        Button(action: { addToFavorite() }) {
            Text("Add palette to favorite")
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
    }
}
