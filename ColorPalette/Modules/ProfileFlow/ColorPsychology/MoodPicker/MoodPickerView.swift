//
//  MoodPickerView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.04.2023.
//

import SwiftUI

struct MoodPickerView: View {
    @StateObject var viewModel: MoodPickerViewModel
    
    var body: some View {
        VStack {
            navBar
            header
            
            buttonsView
            
            colorMoodPreview
            
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private extension MoodPickerView {
    var navBar: some View {
        CustomNavigationBarView(backAction: {})
    }
    
    var header: some View {
        HStack {
            Text("Moods").font(.title.bold())
            Spacer()
        }
        .padding()
    }
    
    var buttonsView: some View {
        LazyVGrid(columns: [
            GridItem(.fixed(90), spacing: 0),
            GridItem(.fixed(90), spacing: 0),
            GridItem(.fixed(90), spacing: 0),
            GridItem(.fixed(90), spacing: 0)
        ]) {
            ForEach(viewModel.output.moods) { mood in
                Button(action: { moodTap(with: mood) }) {
                    Text(mood.rawValue)
                }
            }
        }
        .padding()
        
        
    }
    
    @ViewBuilder
    var colorMoodPreview: some View {
        if viewModel.output.color != .getClear() {
            ColorRowView(appColor: viewModel.output.color, type: .RGB)
                .padding()
        }
    }
}

private extension MoodPickerView {
    func moodTap(with mood: MoodType) {
        viewModel.input.moodSelected.send(mood)
    }
}

struct MoodPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MoodPickerView(viewModel: MoodPickerViewModel())
    }
}
