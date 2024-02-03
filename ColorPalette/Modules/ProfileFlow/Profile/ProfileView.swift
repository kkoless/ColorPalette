//
//  ProfileView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct ProfileView: View {
  @ObservedObject var viewModel: ProfileViewModel
  @EnvironmentObject private var localizationService: LocalizationService
  
  private var isGuest: Bool {
    viewModel.output.email.isEmpty
  }
  
  var body: some View {
    VStack {
      header
      
      Group {
        userInfo
        colorPsychologyCell
        changeLanguageCell
        
        if viewModel.output.role == .free {
          subcriptionInfoCell
        }
        
        aboutCell
        appVersion
      }
      .padding([.top, .bottom], 5)
      
      Spacer()
    }
    .foregroundColor(.primary)
    .padding([.leading, .trailing])
    .onAppear(perform: onAppear)
  }
}

private extension ProfileView {
  private var header: some View {
    HStack {
      Text(.profile)
        .bold()
        .font(.largeTitle)
      Spacer()
    }
  }
  
  private var userInfo: some View {
    HStack {
      VStack(alignment: .leading, spacing: 10) {
        if isGuest {
          Text(.guest)
        } else {
          Text(viewModel.output.email)
        }
        
        Text(viewModel.output.role.title)
      }
      .font(.headline.bold())
      
      Spacer()
      
      Button(action: { profileButtonTap() }) {
        Text(isGuest ? .signIn : .logOut)
      }
    }
    .padding([.top, .bottom])
  }
  
  private var colorPsychologyCell: some View {
    VStack {
      HStack {
        Image(systemName: "eye")
        Text(.colorPsychology)
        Spacer()
      }
      
      Color.gray
        .frame(height: 1)
    }
    .onTapGesture { colorPsychoTap() }
  }
  
  private var changeLanguageCell: some View {
    VStack {
      HStack {
        Image(systemName: "abc")
        
        Text(.language)
        
        Spacer()
        
        Picker(selection: $localizationService.language) {
          Button(action: { languageTap(.russian) }) {
            Text(.russian)
          }
          .tag(Language.russian)
          Button(action: { languageTap(.english) }) {
            Text(.english)
          }
          .tag(Language.english)
        } label: {
          Text(.language)
        }
      }
      
      Color.gray
        .frame(height: 1)
    }
    .padding(.bottom, 10)
    
  }
  
  private var aboutCell: some View {
    VStack {
      HStack {
        Image(systemName: "questionmark.circle")
        Text(.aboutApp)
        Spacer()
      }
    }
  }
  
  private var subcriptionInfoCell: some View {
    VStack {
      HStack {
        Image(systemName: "cart")
        Text(.changeSubscriptionPlan)
        Spacer()
      }
      
      Color.gray
        .frame(height: 1)
    }
    .padding(.bottom, 10)
    .onTapGesture { changeSubscriptionPlanTap() }
  }
  
  private var appVersion: some View {
    Text(Bundle.main.releaseVersionNumberPretty)
      .font(.subheadline)
      .padding(.top)
  }
}

private extension ProfileView {
  private func onAppear() {
    viewModel.input.onAppear.send()
  }

  private func colorPsychoTap() {
    viewModel.input.colorPsychologyTap.send()
  }
  
  private func changeSubscriptionPlanTap() {
    if CredentialsManager.shared.isGuest {
      viewModel.input.signInTap.send()
    } else {
      viewModel.input.showSubscribtionPlansTap.send()
    }
  }
  
  private func languageTap(_ language: Language) {
    viewModel.input.languageTap.send(language)
  }
  
  private func profileButtonTap() {
    if isGuest {
      viewModel.input.signInTap.send()
    } else {
      viewModel.input.logOutTap.send()
    }
  }
}

struct ProfileView_Previews: PreviewProvider {
  static var previews: some View {
    ProfileView(viewModel: ProfileViewModel())
      .environmentObject(LocalizationService.shared)
  }
}
