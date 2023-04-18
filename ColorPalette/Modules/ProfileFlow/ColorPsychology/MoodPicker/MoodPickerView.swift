//
//  MoodPickerView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.04.2023.
//

import SwiftUI

struct MoodPickerView: View {
    @StateObject var viewModel: MoodPickerViewModel = .init()
    var selectedColorTapped: (AppColor) -> ()
    
    init(selectedColorTapped: @escaping (AppColor) -> Void) {
        self.selectedColorTapped = selectedColorTapped
    }
    
    var body: some View {
        VStack(spacing: 0) {
            header
            buttonsView
            colorMoodPreview
        }
    }
}

private extension MoodPickerView {
    var header: some View {
        HStack {
            Text(.moods).font(.headline.bold())
            Spacer()
        }
        .padding(.vertical)
    }
    
    var buttonsView: some View {
        LazyHGrid(rows: [
            GridItem(.fixed(40)),
            GridItem(.fixed(40))
        ], alignment: .center) {
            ForEach(viewModel.output.moods) { mood in
                Button(action: { moodTap(with: mood) }) {
                    Text(mood.buttonText)
                }
                .padding(.horizontal)
            }
        }
        .frame(height: 80)
        .padding(.bottom)
    }
    
    @ViewBuilder
    var colorMoodPreview: some View {
        if viewModel.output.color != .getClear() {
            VStack {
                HStack {
                    Text(viewModel.output.color.name)
                        .font(.headline)
                    Spacer()
                }
                
                Color(viewModel.output.color)
                    .frame(height: 35)
                    .cornerRadius(10)
                    .onTapGesture { colorTap() }
            }
            .padding(.vertical)
        }
    }
}

private extension MoodPickerView {
    func moodTap(with mood: MoodType) {
        viewModel.input.moodSelected.send(mood)
    }
    
    func colorTap() {
        selectedColorTapped(viewModel.output.color)
    }
}

struct MoodPickerView_Previews: PreviewProvider {
    static var previews: some View {
        MoodPickerView() { _ in
            
        }
    }
}
