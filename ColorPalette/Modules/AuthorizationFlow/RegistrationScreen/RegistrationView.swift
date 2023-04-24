//
//  RegistrationView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    @Environment(\.dismiss) private var dismiss: DismissAction
    
    @State private var loginText = ""
    @State private var passwordText = ""
    
    var body: some View {
        VStack {
            topBar
            Spacer()
            header
            registrationForm
            Button(action: registerButtonTap) {
                Text(.createAccount)
            }
            .padding([.top, .bottom])
            Spacer()
        }
        .foregroundColor(.primary)
        .padding()
    }
}

private extension RegistrationView {
    var topBar: some View {
        HStack {
            backButton
            Spacer()
        }
        .padding(.bottom)
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
    
    var backButton: some View {
        Button(action: { dismiss() }) {
            Image(systemName: "multiply")
                .resizable()
                .frame(width: 20, height: 20)
        }
    }
    
    var header: some View {
        HStack {
            Text(.registration)
                .bold()
                .font(.largeTitle)
            Spacer()
        }
    }
    
    var registrationForm: some View {
        VStack {
            VStack(spacing: 20) {
                Group {
                    emailTextField
                    passwordTextField
                }
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 16)
                        .stroke(.primary, lineWidth: 1)
                )
            }
            
        }
        .padding([.top, .bottom])
    }
}

private extension RegistrationView {
    func registerButtonTap() {
        viewModel.input.registrTap.send((loginText, passwordText))
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel())
    }
}
