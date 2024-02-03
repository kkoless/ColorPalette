//
//  CustomNavigationBarView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 26.12.2022.
//

import SwiftUI

struct CustomNavigationBarAppearance: ViewModifier {
  func body(content: Content) -> some View {
    content
      .padding([.leading, .trailing], 16)
      .padding(.top, Consts.Constraints.top + 45)
      .padding(.bottom)
  }
}

struct CustomNavigationBarTitleAppearance: ViewModifier {
  let font: Font
  let isBold: Bool
  let opacity: Double
  
  func body(content: Content) -> some View {
    content
      .font(isBold ? font.bold() : font)
      .opacity(opacity)
  }
}

struct CustomNavigationBarView: View {
  let backgroundColor: Color
  
  @State private var titleText: Strings
  
  private var backAction: () -> Void
  
  private var foregroundColor: Color {
    if backgroundColor == .systemCustomBackground {
      .invertedSystemCustomBackground
    } else {
      Color(uiColor: backgroundColor.uiColor.invertColor())
    }
  }
  
  init(
    backAction: @escaping () -> Void,
    titleText: Strings = .none,
    backgroundColor: Color = .systemCustomBackground
  ) {
    self.backAction = backAction
    self.titleText = titleText
    self.backgroundColor = backgroundColor
  }
  
  var body: some View {
    HStack(spacing: 0) {
      backButton
      Spacer()
      title
      Spacer()
    }
    .background(backgroundColor)
    .foregroundColor(foregroundColor)
    .setCustomNavigationBarAppearance()
  }
}

private extension CustomNavigationBarView {
  private var backButton: some View {
    Button(action: { backAction() }) {
      Image(systemName: "chevron.left")
        .resizable()
        .frame(width: 10, height: 20)
    }
  }
  
  private var title: some View {
    Text(titleText)
      .setCustomNavigationBarTitleAppearance()
  }
}

extension CustomNavigationBarView {
  func setTitleText(_ text: Strings) {
    self.titleText = text
  }
}

extension CustomNavigationBarView {
  func trailingItems<Content: View>(
    @ViewBuilder items: @escaping () -> Content
  ) -> some View {
    HStack {
      backButton
      Spacer()
      title
      Spacer()
      items()
    }
    .setCustomNavigationBarAppearance()
  }
}


struct CustomNavigationBarView_Previews: PreviewProvider {
  static var previews: some View {
    VStack {
      CustomNavigationBarView(backAction: {})
        .trailingItems {
          Button(action: {}) {
            Image(systemName: "plus")
              .resizable()
              .frame(width: 18, height: 18)
              .padding(.trailing)
          }
          
          Button(action: {}) {
            Image(systemName: "checkmark")
              .resizable()
              .frame(width: 18, height: 18)
          }
        }
      
      Spacer()
    }
  }
}
