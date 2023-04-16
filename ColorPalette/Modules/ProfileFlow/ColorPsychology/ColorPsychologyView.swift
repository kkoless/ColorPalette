//
//  ColorPsychologyView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.04.2023.
//

import SwiftUI

struct ColorPsychologyView: View {
    var body: some View {
        VStack {
            navBar
            ScrollView {
                header
                textView
                pickMoodButton
            }
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private extension ColorPsychologyView {
    var navBar: some View {
        CustomNavigationBarView(backAction: { backTap() })
    }
    
    var header: some View {
        HStack {
            Text("Color Psychology")
                .font(.title.bold())
            Spacer()
        }
        .padding()
    }
    
    var textView: some View {
        Text("Some text about color psychology...")
    }
    
    var pickMoodButton: some View {
        Button(action: { pickMoodTap() }) {
            Text("Pick mood")
        }
        .padding()
    }
}

private extension ColorPsychologyView {
    func pickMoodTap() {
        
    }
    
    func backTap() {
        
    }
}

struct ColorPsychologyView_Previews: PreviewProvider {
    static var previews: some View {
        ColorPsychologyView()
    }
}
