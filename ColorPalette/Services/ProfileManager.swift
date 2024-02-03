//
//  ProfileManager.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 31.12.2022.
//

import Combine

final class ProfileManager: ObservableObject {
  @Published private(set) var profile: Profile = .getEmptyProfile()
  
  static let shared = ProfileManager()
  
  private var cancellable: Set<AnyCancellable> = .init()
  
  // Network manager
  
  private init() {
    print("\(self) INIT")
  }
  
  deinit {
    cancellable.forEach { $0.cancel() }
    cancellable.removeAll()
    
    print("\(self) DEINIT")
  }
}

extension ProfileManager {
  func setProfile(_ newProfile: Profile) {
    CredentialsManager.shared.isGuest = false
    CredentialsManager.shared.token = newProfile.accessTokenData.access_token
    self.profile = newProfile
  }
  
  func logOut() {
    CredentialsManager.shared.isGuest = true
    CredentialsManager.shared.token = nil
    self.profile = .getEmptyProfile()
  }
}
