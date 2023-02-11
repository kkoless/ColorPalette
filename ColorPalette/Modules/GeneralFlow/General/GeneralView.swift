//
//  GeneralView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct GeneralView: View {
    @StateObject var viewModel: GeneralViewModel
    
    var body: some View {
        VStack {
            header
            
            Spacer()
            
            buttons
            
            Spacer()
        }
        .onAppear(perform: onAppear)
    }
}

private extension GeneralView {
    var header: some View {
        HStack {
            Text("General")
                .bold()
                .font(.largeTitle)
            Spacer()
        }
        .padding()
    }
    
    var buttons: some View {
        VStack(spacing: 20) {
            Button(action: { navigateToSamplePalettes() }) {
                Text("Go to sample palettes")
            }
            
            Button(action: { navigateToSampleColors() }) {
                Text("Go to sample colors")
            }
        }
    }
}

private extension GeneralView {
    func onAppear() {
        viewModel.input.onAppear.send()
    }
    
    func navigateToSamplePalettes() {
        viewModel.input.palettesTap.send()
    }
    
    func navigateToSampleColors() {
        viewModel.input.colorsTap.send()
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView(viewModel: GeneralViewModel())
    }
}
