//
//  LoginView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct LoginView: View {
    @StateObject var viewModel: LoginViewModel
    
    @State private var loginText = ""
    @State private var passwordText = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text("Authorization")
                .bold()
                .font(.largeTitle)
            Spacer()
            loginForm
            Spacer()
            
            Button(action: registerButtonTap) {
                Text("Register")
            }
            .padding()
        }
    }
}

extension LoginView {
    var loginForm: some View {
        VStack {
            Group {
                TextField("Email", text: $loginText)
                TextField("Password", text: $passwordText)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.blue, lineWidth: 2)
            )
            
            Button(action: loginButtonTap) {
                Text("Login")
            }
            .padding()
        }
        .padding()
    }
}

extension LoginView {
    func loginButtonTap() {
        
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
