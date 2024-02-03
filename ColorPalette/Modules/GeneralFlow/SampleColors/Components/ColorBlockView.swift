//
//  ColorBlockView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import SwiftUI

struct ColorBlockView: View {
  private let uiColor: UIColor
  private let colorName: String
  private let alpha: CGFloat
  private let type: ColorType
  
  init(appColor: AppColor, type: ColorType) {
    self.uiColor = UIColor(hexString: appColor.hex, alpha: appColor.alpha)
    self.colorName = appColor.name
    self.alpha = appColor.alpha
    self.type = type
  }
  
  var body: some View {
    HStack() {
      colorPreview
      colorInfo
      Spacer()
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension ColorBlockView {
  var colorPreview: some View {
    Color(uiColor)
      .opacity(alpha)
      .frame(width: 80, height: 80)
      .cornerRadius(10)
  }
  
  var colorInfo: some View {
    VStack(alignment: .leading) {
      Text(colorName)
        .font(.headline)
        .bold()
      
      Text(uiColor.getTypeInfo(type: type, isExtended: false))
        .font(.subheadline)
    }
  }
}

struct ColorBlockView_Previews: PreviewProvider {
  static var previews: some View {
    ColorBlockView(appColor: AppColor.getRandomColor(), type: .HEX)
      .padding()
  }
}
