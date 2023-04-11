//
//  CustomNavigationBarView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 26.12.2022.
//

import SwiftUI
import Combine

struct CustomNavigationBarAppearance: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding([.leading, .trailing], 16)
            .padding(.top, Consts.Constraints.top + 45)
            .padding(.bottom)
            .foregroundColor(.primary)
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
            .foregroundColor(.primary)
    }
}

struct CustomNavigationBarView: View {
    @State private var titleText: String
    private var backAction: () -> Void
    
    init(backAction: @escaping () -> Void, titleText: String = "") {
        self.backAction = backAction
        self.titleText = titleText
    }
    
    var body: some View {
        HStack(spacing: 0) {
            backButton
            Spacer()
            title
            Spacer()
        }
        .setCustomNavigationBarAppearance()
    }
}

private extension CustomNavigationBarView {
    var backButton: some View {
        Button(action: { backAction() }) {
            Image(systemName: "chevron.left")
                .resizable()
                .frame(width: 10, height: 20)
        }
    }
    
    var title: some View {
        Text(titleText)
            .setCustomNavigationBarTitleAppearance()
    }
}

extension CustomNavigationBarView {
    func setTitleText(_ text: Strings) {
        self.titleText = text.rawValue
    }
}

extension CustomNavigationBarView {
    func trailingItems<Content: View>(@ViewBuilder items: @escaping () -> Content) -> some View {
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
