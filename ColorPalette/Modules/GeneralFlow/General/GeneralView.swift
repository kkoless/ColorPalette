//
//  GeneralView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct GeneralView: View {
    weak var router: GeneralRoutable?
    
    var body: some View {
        VStack {
            header
            
            Spacer()
            
            buttons
            
            Spacer()
        }
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
            
            Button(action: { navigateToImageColorDetection() }) {
                Text("Detect colors on image")
            }
        }
    }
}

private extension GeneralView {
    func navigateToSamplePalettes() {
        router?.navigateToSamplePalettes()
    }
    
    func navigateToSampleColors() {
        router?.navigateToSampleColors()
    }
    
    func navigateToImageColorDetection() {
        router?.navigateToImageColorDetection()
    }
}

struct GeneralView_Previews: PreviewProvider {
    static var previews: some View {
        GeneralView()
    }
}
