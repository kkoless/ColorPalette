//
//  RegistrationView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct RegistrationView: View {
    @State private var loginText = ""
    @State private var passwordText = ""
    
    @ObservedObject var viewModel: RegistrationViewModel
    
    var body: some View {
        VStack {
            Spacer()
            Text("Registration")
                .bold()
                .font(.largeTitle)
            Spacer()
            registrationForm
            Spacer()
            Button(action: registerButtonTap) {
                Text("Create account")
            }
            .padding()
        }
    }
}

extension RegistrationView {
    var registrationForm: some View {
        VStack {
            Group {
                TextField("Email", text: $loginText)
                SecureField("Password", text: $passwordText)
            }
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 16)
                    .stroke(.blue, lineWidth: 2)
            )
        }
        .padding()
    }
}

extension RegistrationView {
    func registerButtonTap() {
        viewModel.input.registrTap.send((loginText, passwordText))
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView(viewModel: RegistrationViewModel())
    }
}
