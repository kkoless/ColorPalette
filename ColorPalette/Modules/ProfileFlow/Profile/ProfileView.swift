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
    
    var body: some View {
        VStack {
            header
            
            if viewModel.output.profile != nil {
                profileBlock
            }
            else {
                guestBlock
            }
            
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
            Button(action: { settingsTap() }) {
                Image(systemName: "gearshape")
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundColor(.primary)
            }
        }
    }
    
    var profileBlock: some View {
        VStack {
            userAvatarView
            
            userInfo
            
            Spacer()
            
            Button(action: { logOutTap() }) {
                Text(.logOut)
            }
        }
        .padding([.leading, .trailing])
    }
    
    var guestBlock: some View {
        VStack {
            Spacer()
            Button(action: { signInTap() }) {
                Text(.signIn)
            }
            .padding(.bottom, 50)
        }
    }
}

private extension ProfileView {
    var userAvatarView: some View {
        Circle()
            .foregroundColor(.gray)
            .frame(width: 150, height: 150)
            .shadow(radius: 20)
    }
    
    var userInfo: some View {
        VStack {
            Text(viewModel.output.profile?.email ?? "")
                .padding([.top, .bottom], 15)
            Text(viewModel.output.profile?.role.title ?? "")
        }
        .font(.subheadline)
    }
}

private extension ProfileView {
    func onAppear() { viewModel.input.onAppear.send() }
    
    func settingsTap() { viewModel.input.settingsTap.send() }
    
    func signInTap() { viewModel.input.signInTap.send() }
    
    func logOutTap() { viewModel.input.logOutTap.send() }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
            .environmentObject(LocalizationService.shared)
    }
}
