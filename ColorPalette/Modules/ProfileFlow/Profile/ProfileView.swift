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
    
    var isGuest: Bool {
        viewModel.output.email.isEmpty
    }
    
    var body: some View {
        VStack {
            header
            
            Group {
                userInfo
                changeLanguageCell
                socialNetworksCell
                
                if viewModel.output.role == .free {
                    subcriptionInfoCell
                }
                
                aboutCell
                appVersion
            }
            .padding([.top, .bottom], 5)
            
            Spacer()
        }
        .padding([.leading, .trailing])
        .onAppear(perform: onAppear)
    }
}

private extension ProfileView {
    var header: some View {
        HStack {
            Text(.profile)
                .bold()
                .font(.largeTitle)
            Spacer()
        }
    }
    
    var userInfo: some View {
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
    
    var changeLanguageCell: some View {
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
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .foregroundColor(.gray)
        )
    }
    
    var aboutCell: some View {
        HStack {
            Image(systemName: "questionmark.circle")
            Text(.aboutApp)
            Spacer()
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .foregroundColor(.gray)
        )
    }
    
    var socialNetworksCell: some View {
        VStack {
            HStack {
                Image(systemName: "network")
                Text(.socialNetworks)
                Spacer()
                
                ForEach(SocialNetwork.allCases) { type in
                    Image(type.iconName)
                        .resizable()
                        .frame(width: type.iconSize.0,
                               height: type.iconSize.1)
                        .foregroundColor(type.foregroundColor)
                        .padding(.leading, 5)
                }
            }
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .foregroundColor(.gray)
        )
    }
    
    var subcriptionInfoCell: some View {
        HStack {
            Image(systemName: "cart")
            Text(.changeSubscriptionPlan)
            Spacer()
        }
        .padding()
        .overlay(
            RoundedRectangle(cornerRadius: 10)
                .stroke()
                .foregroundColor(.gray)
        )
    }
    
    var appVersion: some View {
        Text(Bundle.main.releaseVersionNumberPretty)
            .font(.subheadline)
            .padding(.top)
    }
}

private extension ProfileView {
    func onAppear() { viewModel.input.onAppear.send() }
    
    func languageTap(_ language: Language) { viewModel.input.languageTap.send(language)
    }
    
    func profileButtonTap() {
        if isGuest { viewModel.input.signInTap.send() }
        else { viewModel.input.logOutTap.send() }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
            .environmentObject(LocalizationService.shared)
    }
}
