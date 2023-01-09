//
//  ProfileView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct ProfileView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
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
        .padding()
    }
}

private extension ProfileView {
    var header: some View {
        HStack {
            Text("Profile")
                .bold()
                .font(.largeTitle)
            Spacer()
        }
    }
    
    var profileBlock: some View {
        VStack {
            userAvatarView
            
            userInfo
           
            changeRoleButton
            
            Spacer()
            
            Button(action: { logOutTap() }) {
                Text("Log out")
            }
        }
    }
    
    var guestBlock: some View {
        VStack {
            Spacer()
            Button(action: { signInTap() }) {
                Text("Sign In")
            }
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
            Text(viewModel.output.profile?.username ?? "EMPTY")
                .font(.headline)
            
            Text(viewModel.output.profile?.role ?? "NONE")
                .font(.subheadline)
                .bold()
        }
    }
    
    var changeRoleButton: some View {
        Button(action: { changeRole() }) {
            Text("Change role")
        }
    }
}

private extension ProfileView {
    func signInTap() {
        viewModel.input.signInTap.send()
    }
    
    func changeRole() {
        viewModel.input.changeRoleTap.send()
    }
    
    func logOutTap() {
        viewModel.input.logOutTap.send()
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(viewModel: ProfileViewModel())
    }
}
