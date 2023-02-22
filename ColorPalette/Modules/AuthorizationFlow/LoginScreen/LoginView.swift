//
//  LoginView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @EnvironmentObject private var localizationService: LocalizationService
    
    @State private var loginText = ""
    @State private var passwordText = ""
    
    var body: some View {
        VStack {
            Spacer()
            header
            loginForm
            buttonsBlock
        }
        .padding()
    }
}

private extension LoginView {
    var header: some View {
        HStack {
            Text(.authorization)
                .bold()
                .font(.largeTitle)
            Spacer()
        }
    }
    
    var loginForm: some View {
        VStack {
            VStack(spacing: 20) {
                Group {
                    TextField("email", text: $loginText)
                    SecureField("password", text: $passwordText)
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.black, lineWidth: 1)
                )
                
            }
        }
        .padding([.top, .bottom])
    }
    
    var buttonsBlock: some View {
        VStack(spacing: 20) {
            Button(action: loginButtonTap) {
                Text(.signIn)
            }
            
            Button(action: registerButtonTap) {
                Text(.registration)
            }
        }
        .padding([.top, .bottom])
    }
}

private extension LoginView {
    func loginButtonTap() {
        viewModel.input.loginTap.send((loginText, passwordText))
    }
    
    func registerButtonTap() {
        viewModel.input.registerTap.send()
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewModel: LoginViewModel(router: nil))
            .environmentObject(LocalizationService.shared)
    }
}
