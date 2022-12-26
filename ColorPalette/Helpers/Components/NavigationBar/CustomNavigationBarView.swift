//
//  CustomNavigationBarView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 26.12.2022.
//

import SwiftUI
import Combine

struct CustomNavigationBarView: View {
    private let title: String
    private let trailingItems: [Button<Image>]
    private let backAction: () -> Void
    
    init(backAction: @escaping () -> Void,
         title: String = "",
         trailingItems: [Button<Image>] = []) {
        self.backAction = backAction
        self.title = title
        self.trailingItems = trailingItems
    }
    
    var body: some View {
        HStack(spacing: 0) {
            backButton
            Spacer()
            
            if !title.isEmpty {
                titleBlock
                Spacer()
            }
            
            if !trailingItems.isEmpty {
                trailingItemsBlock
            }
        }
        .padding(.top, 45)
        .padding([.leading, .trailing, .bottom])
        .frame(maxWidth: .infinity)
        .foregroundColor(tintColor)
        .background(backgroundColor.edgesIgnoringSafeArea(.top))
    }
}

private extension CustomNavigationBarView {
    var backButton: some View {
        Button(action: { self.backAction() }) {
            Image(systemName: "chevron.left")
        }
    }
    
    var titleBlock: some View {
        Text(title)
            .font(.headline)
            .bold()
    }
    
    var trailingItemsBlock: some View {
        HStack(spacing: 25) {
            ForEach(0..<trailingItems.count) { index in
                self.trailingItems[index]
            }
        }
    }
}

private extension CustomNavigationBarView {
    private var backgroundColor: Color {
        Color(UIColor(named: "systemBackground") ?? .clear)
    }
    private var tintColor: Color {
        Color(backgroundColor.uiColor.invertColor())
    }
}

struct CustomNavigationBarView_Previews: PreviewProvider {
    static var previews: some View {
        let buttons: [Button<Image>] = [
            Button(action: {}, label: {
                Image(systemName: "square.and.arrow.up")
            }),
            Button(action: {}, label: {
                Image(systemName: "trash")
            })
        ]
        VStack {
            CustomNavigationBarView(backAction: { }, trailingItems: buttons)
            Spacer()
        }
    }
}
