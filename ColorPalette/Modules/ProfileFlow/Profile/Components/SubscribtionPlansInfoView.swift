//
//  SubscribtionPlansInfoView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 23.04.2023.
//

import SwiftUI

struct SubscribtionPlansInfoView: View {
    var backgroundColor: Color {
        Color(uiColor: UIColor(hexString: "#E52B50"))
    }
    var foregroundColor: Color {
        Color(uiColor: backgroundColor.uiColor.invertColor())
    }
    
    
    var body: some View {
        VStack {
            Spacer()
            Image("thirdOnboarding")
                .resizable()
                .frame(width: 200, height: 200)
                .padding(.bottom, 30)
            infoBlock
            Spacer()
            subscribeButton
        }
        .padding()
        .background(backgroundColor)
        .foregroundColor(foregroundColor)
    }
}

private extension SubscribtionPlansInfoView {
    var infoBlock: some View {
        VStack(alignment: .leading) {
            Text(.paidSubscribtionInfoText)
                .padding(.bottom, 15)
            
            Group {
                makeListPoint(with: .paidSubscribtionInfo1Point)
                makeListPoint(with: .paidSubscribtionInfo2Point)
                makeListPoint(with: .paidSubscribtionInfo3Point)
                makeListPoint(with: .paidSubscribtionInfo4Point)
                makeListPoint(with: .paidSubscribtionInfo5Point)
            }
            .padding(.bottom, 5)
        }
    }
    
    var subscribeButton: some View {
        Button(action: {  }) { Text(.subscribe).bold() }
            .padding(.bottom)
    }
}

private extension SubscribtionPlansInfoView {
    func makeListPoint(with text: Strings) -> some View {
        HStack {
            Image(systemName: "smallcircle.filled.circle")
                .resizable()
                .frame(width: 10, height: 10)
            Text(text)
                .font(.callout.bold())
                .padding(.leading, 5)
        }
    }
}

struct SubscribtionPlansInfoView_Previews: PreviewProvider {
    static var previews: some View {
        SubscribtionPlansInfoView()
    }
}
