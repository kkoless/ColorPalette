//
//  RegistrationView.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 30.11.2022.
//

import SwiftUI

struct RegistrationView: View {
    @StateObject var viewModel: RegistrationViewModel
    @EnvironmentObject private var localizationService: LocalizationService
    
    @State private var loginText = ""
    @State private var passwordText = ""
    
    var body: some View {
        VStack {
            Spacer()
            Text(.registration)
                .bold()
                .font(.largeTitle)
            Spacer()
            registrationForm
            Spacer()
            Button(action: registerButtonTap) {
                Text(.createAccount)
            }
            .padding()
        }
    }
}

extension RegistrationView {
    var registrationForm: some View {
        VStack {
            Group {
                TextField("email", text: $loginText)
                SecureField("password", text: $passwordText)
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
            .environmentObject(LocalizationService.shared)
    }
}
