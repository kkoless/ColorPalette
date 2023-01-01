//
//  ProfileManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 31.12.2022.
//

import Foundation

final class ProfileManager: ObservableObject {
    @Published private(set) var profile: Profile? = nil
    
    static let shared = ProfileManager()
    
    // Network manager
    
    private init() {
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

extension ProfileManager {
    func fetchProfile() {
        CredentialsManager.shared.isGuest = false
        self.profile = Profile(username: "kkolesss", role: .paid)
    }
    
    func logOut() {
        CredentialsManager.shared.isGuest = true
        self.profile = nil
    }
}
