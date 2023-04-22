//
//  LoginView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State private var loginText = ""
    @State private var passwordText = ""
    
    var body: some View {
        VStack {
            topBar
            Spacer()
            header
            loginForm
            buttonsBlock
        }
        .padding()
    }
}

private extension LoginView {
    var topBar: some View {
        HStack {
            backButton
            Spacer()
        }
        .padding(.bottom)
    }
    
    var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "multiply")
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundColor(.invertedSystemCustomBackground)
        }
    }
    
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
                    emailTextField
                    passwordTextField
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(Color.invertedSystemCustomBackground, lineWidth: 1)
                )
                
            }
        }
        .padding([.top, .bottom])
    }
    
    var emailTextField: some View {
        ZStack {
            TextField("", text: $loginText)
            if loginText.isEmpty {
                HStack {
                    Text(.email).foregroundColor(.gray)
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
    }
    
    var passwordTextField: some View {
        ZStack {
            SecureField("", text: $passwordText)
            if passwordText.isEmpty {
                HStack {
                    Text(.password).foregroundColor(.gray)
                    Spacer()
                }
                .allowsHitTesting(false)
            }
        }
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
    }
}
