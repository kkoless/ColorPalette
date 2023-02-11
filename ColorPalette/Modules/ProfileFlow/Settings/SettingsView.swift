//
//  SettingsView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.02.2023.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss: DismissAction
    @EnvironmentObject private var localizationService: LocalizationService
    
    var body: some View {
        VStack {
            navigationBar
            header
            changeLanguageMenu
            Spacer()
        }
        .edgesIgnoringSafeArea(.top)
    }
}

private extension SettingsView {
    var navigationBar: some View {
        CustomNavigationBarView(backAction: { dismiss() })
    }
    
    var header: some View {
        HStack {
            Text(.settings)
                .font(.largeTitle.bold())
            Spacer()
        }
        .padding([.leading, .trailing])
    }
    
    var changeLanguageMenu: some View {
        HStack {
            Menu {
                Button(action: { changeLanguage(.russian) }) {
                    Text(.russian)
                }
                Button(action: { changeLanguage(.english) }) {
                    Text(.english)
                }
            } label: {
                Text(.changeLanguage)
            }
            
            Spacer()
        }
        .padding([.leading, .trailing])
        .padding([.top, .bottom], 10)
    }
}

private extension SettingsView {
    func changeLanguage(_ language: Language) {
        localizationService.language = language
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
            .environmentObject(LocalizationService.shared)
    }
}
