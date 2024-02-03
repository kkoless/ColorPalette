//
//  ColorTypePickerView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.12.2022.
//

import SwiftUI

enum ColorType: String, CaseIterable {
  case HEX, RGB, HSB, CMYK
}

extension ColorType: Identifiable {
  var id: Int {
    switch self {
    case .HEX: return 0
    case .RGB: return 1
    case .HSB: return 2
    case .CMYK: return 3
    }
  }
}

struct ColorTypePickerView: View {
  @Binding var selectedType: ColorType
  
  var body: some View {
    GeometryReader { geometry in
      ScrollView(.horizontal) {
        HStack(spacing: 0) {
          ForEach(ColorType.allCases) { type in
            Button(action: { selectedType = type }) {
              getblockType(type: type)
            }
            .buttonStyle(.plain)
            .padding()
          }
        }
        .frame(width: geometry.size.width)
      }
    }
    .frame(height: 60)
  }
}

private extension ColorTypePickerView {
  @ViewBuilder
  func getblockType(type: ColorType) -> some View {
    GeometryReader { geomentry in
      VStack {
        Text(type.rawValue)
        
        if selectedType == type {
          Color.gray
            .frame(width: geomentry.size.width, height: 2)
        }
      }
      .frame(width: geomentry.size.width)
    }
  }
}

struct ColorTypePickerView_Previews: PreviewProvider {
  static var previews: some View {
    ColorTypePickerView(selectedType: Binding<ColorType>(projectedValue: .constant(.RGB)))
  }
}
