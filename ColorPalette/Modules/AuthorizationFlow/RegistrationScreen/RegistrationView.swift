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
            header
            registrationForm
            Button(action: registerButtonTap) {
                Text(.createAccount)
            }
            .padding([.top, .bottom])
        }
        .padding()
    }
}

private extension RegistrationView {
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
}

private extension RegistrationView {
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
