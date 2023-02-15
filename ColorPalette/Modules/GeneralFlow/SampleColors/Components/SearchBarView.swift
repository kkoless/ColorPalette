//
//  SearchBarView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.12.2022.
//

import SwiftUI

struct SearchBarView: View {
    @EnvironmentObject private var localizationService: LocalizationService
    @Binding var searchText: String
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundColor(.gray)
            
            TextField(String(.search).localized(localizationService.language), text: $searchText)
                .font(.system(size: 16))
            
            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "clear.fill")
                        .foregroundColor(.gray)
                }
            }
        }
        .padding([.leading, .trailing])
        .padding([.top, .bottom], 10)
        .overlay {
            RoundedRectangle(cornerRadius: 10)
                .stroke(.gray, lineWidth: 1)
        }
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            SearchBarView(searchText: .constant(""))
                .environmentObject(LocalizationService.shared)
            Spacer()
        }
        .padding()
    }
}
