//
//  ColorPsychologyView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.04.2023.
//

import SwiftUI

struct ColorPsychologyView: View {
  @StateObject var viewModel: ColorPsychologyViewModel
  
  var body: some View {
    VStack {
      navBar
      ScrollView {
        header
        textView
      }
      Spacer()
    }
    .foregroundColor(.primary)
    .edgesIgnoringSafeArea(.top)
  }
}

private extension ColorPsychologyView {
  private var navBar: some View {
    CustomNavigationBarView(backAction: { backTap() })
  }
  
  private var header: some View {
    HStack {
      Text(.colorPsychology).font(.title.bold())
      Spacer()
    }
    .padding(.horizontal)
  }
  
  private var textView: some View {
    VStack(alignment: .leading) {
      Image("colorPsychology1")
        .resizable()
        .aspectRatio(contentMode: .fit)
        .cornerRadius(10)
      
      Group {
        Text(.colorPsychologyTitle).font(.title3.bold())
          .padding(.top)
        Text(.colorPsychologyText1)
        Text(.colorPsychologyText2)
      }
      .padding(.bottom, 5)
      
      Group {
        Text(.colorPsychologyHeadline1).font(.headline.bold())
        Text(.colorPsychologyText3)
        Text(.colorPsychologyText4)
      }
      .padding(.bottom, 5)
      
      // Mood
      Group {
        Text(.colorPsychologyHeadline2).font(.headline.bold())
        Text(.colorPsychologyText5)
        MoodPickerView { color in colorTap(with: color) }
        Text(.colorPsychologyText6)
      }
      .padding(.bottom, 5)
      
      Group {
        Text(.colorPsychologyHeadline3).font(.headline.bold())
        Text(.colorPsychologyText7)
      }
      .padding(.bottom, 5)
    }
    .padding(.horizontal)
  }
}

private extension ColorPsychologyView {
  private func backTap() {
    viewModel.input.backTap.send()
  }
  
  private func colorTap(with color: AppColor) {
    viewModel.input.colorTap.send(color)
  }
}

struct ColorPsychologyView_Previews: PreviewProvider {
  static var previews: some View {
    ColorPsychologyView(viewModel: ColorPsychologyViewModel())
  }
}
