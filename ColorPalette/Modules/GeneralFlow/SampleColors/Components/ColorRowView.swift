//
//  ColorRowView.swift
//  ColorPalette
//
//  Created by Kolesnikov Kirill on 23.12.2022.
//

import SwiftUI

struct ColorRowView: View {
  let appColor: AppColor
  let type: ColorType

  @EnvironmentObject private var viewModel: SampleColorsViewModel

  var body: some View {
    HStack() {
      ColorBlockView(appColor: appColor, type: type)
        .onTapGesture { previewTap() }
    }
    .frame(maxWidth: .infinity, alignment: .leading)
  }
}

private extension ColorRowView {
  private func previewTap() {
    viewModel.input.colorTap.send(appColor)
  }
}

struct ColorRowView_Previews: PreviewProvider {
  static var previews: some View {
    ColorRowView(appColor: AppColor(name: "African Violet", hex: "#B284BE"),
                 type: .RGB)
  }
}
