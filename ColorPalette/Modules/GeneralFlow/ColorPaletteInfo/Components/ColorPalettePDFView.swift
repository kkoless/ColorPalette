//
//  ColorPalettePDFView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.02.2023.
//

import SwiftUI

struct ColorPalettePDFView: View {
  let palette: ColorPalette
  let type: ColorType

  var body: some View {
    VStack(spacing: 0) {
      ForEach(palette.colors) { color in
        makeColorRow(color)
      }
    }
  }
}

private extension ColorPalettePDFView {
  private func makeColorRow(_ color: AppColor) -> some View {
    ZStack {
      Color(color).opacity(color.alpha)
      getColorInfo(color: color.uiColor)
    }
  }

  private func getColorInfo(color: UIColor) -> some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          Text(type.rawValue)
            .font(.title2).bold()
          Text(color.getTypeInfo(type: type, isExtended: true))
            .font(.title3)
        }
        .foregroundColor(Color(color.invertColor()).opacity(1))
        .minimumScaleFactor(0.1)

        Spacer()
      }
      .padding(.all)

      Spacer()
    }
  }
}

struct ColorPalettePDFView_Previews: PreviewProvider {
  static var previews: some View {
    let palette = PopularPalettesManager.shared.palettes[0]
    ColorPalettePDFView(palette: palette, type: .RGB)
  }
}
