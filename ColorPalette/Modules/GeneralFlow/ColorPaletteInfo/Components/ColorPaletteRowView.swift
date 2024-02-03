//
//  ColorPaletteRowView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 25.12.2022.
//

import SwiftUI

struct ColorPaletteRowView: View {
  let appColor: AppColor
  let type: ColorType
  let showInfo: Bool
  
  var body: some View {
    ZStack {
      Color(appColor).opacity(appColor.alpha)
      
      HStack {
        if showInfo {
          getColorInfo(color: appColor.uiColor)
          copyButton
        }
      }
    }
  }
}

private extension ColorPaletteRowView {
  @ViewBuilder
  private func getColorInfo(color: UIColor) -> some View {
    VStack {
      HStack {
        VStack(alignment: .leading) {
          Text(type.rawValue)
            .font(.title2)
            .bold()
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
  
  private var copyButton: some View {
    Button(action: { copyTap() }) {
      Image(systemName: "clipboard")
        .resizable()
        .frame(width: 19, height: 24)
    }
    .foregroundColor(Color(appColor.uiColor.invertColor()).opacity(1))
    .padding()
  }
}

private extension ColorPaletteRowView {
  private func copyTap() {
    switch type {
    case .HEX:
      UIPasteboard.general.string = appColor.uiColor.hexValue
    case .RGB:
      UIPasteboard.general.string = appColor.uiColor.getRGBCopyInfo()
    case .HSB:
      UIPasteboard.general.string = appColor.uiColor.getHSBCopyInfo()
    case .CMYK:
      UIPasteboard.general.string = appColor.uiColor.getCMYKCopyInfo()
    }
  }
}

struct ColorPaletteRowView_Previews: PreviewProvider {
  static var previews: some View {
    ColorPaletteRowView(appColor: AppColor.getRandomColor(), type: .RGB, showInfo: true)
  }
}
