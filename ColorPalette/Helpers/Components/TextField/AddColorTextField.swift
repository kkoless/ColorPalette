//
//  AddColorTextField.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 13.03.2023.
//

import SwiftUI

struct AddColorTextField: View {
  @EnvironmentObject private var localizationService: LocalizationService
  @Binding var text: String
  
  var body: some View {
    ZStack {
      if text.isEmpty {
        HStack {
          Text(.colorName)
            .foregroundColor(.gray)
          Spacer()
        }
      }
      TextField("", text: $text)
        .font(.system(size: 16))
    }
  }
}

struct AddColorTextField_Previews: PreviewProvider {
  static var previews: some View {
    AddColorTextField(text: .constant(""))
      .environmentObject(LocalizationService.shared)
  }
}
