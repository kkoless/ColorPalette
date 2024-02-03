//
//  ImagePreviewerView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.05.2023.
//

import SwiftUI

struct ImagePreviewerView: View {
  @Environment(\.dismiss) private var dismiss: DismissAction
  @State private var showSheet = false

  let image: UIImage

  var backgrounColor: Color {
    Color(uiColor: image.averageColor ?? .systemCustomBackground)
  }
  var foregroundColor: Color {
    Color(
      uiColor: image.averageColor?.invertColor() ?? .invertedSystemCustomBackground
    )
  }

  var body: some View {
    VStack {
      HStack {
        backButton
        Spacer()
        shareButton
      }
      .padding([.top, .leading, .trailing], 20)

      ZStack {
        backgrounColor
        preview
      }
    }
    .background(backgrounColor)
    .foregroundColor(foregroundColor)
    .sheet(
      isPresented: $showSheet,
      onDismiss: { showSheet = false }
    ) {
      ShareSheet(urls: [image])
    }
  }
}

private extension ImagePreviewerView {
  var backButton: some View {
    Button(action: { dismiss() }) {
      Image(systemName: "multiply")
        .resizable()
        .frame(width: 20, height: 20)
    }
  }

  var shareButton: some View {
    Button(action: { showSheet = true }, label: {
      Image(systemName: "square.and.arrow.up")
        .resizable()
        .frame(width: 20, height: 25)
    })
  }

  var preview: some View {
    Image(uiImage: image)
      .resizable()
      .aspectRatio(contentMode: .fit)
  }
}

struct ImagePreviewerView_Previews: PreviewProvider {
  static var previews: some View {
    ImagePreviewerView(image: UIImage())
  }
}
