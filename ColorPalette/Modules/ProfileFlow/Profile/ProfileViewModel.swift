//
//  ProfileViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 31.12.2022.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private let profileManager: ProfileManager
    private let service: ProfileServiceProtocol
    private weak var router: ProfileRoutable?
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: ProfileRoutable? = nil,
         service: ProfileServiceProtocol = AuthorizationNetworkService.shared) {
        self.input = Input()
        self.output = Output()
        self.router = router
        self.service = service
        self.profileManager = ProfileManager.shared
        
        bindProfile()
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

private extension ProfileViewModel {
    func bindProfile() {
        input.onAppear
            .filter { _ in !CredentialsManager.shared.isGuest }
            .flatMap { [unowned self] _ -> AnyPublisher<Profile, ApiError>  in
                self.service.fetchProfile()
            }
            .sink { response in
                switch response {
                    case.failure(let apiError):
                        print(apiError.localizedDescription)
                    case .finished:
                        print("finished")
                }
            } receiveValue: { [weak self] profile in
                self?.profileManager.setProfile(profile)
            }
            .store(in: &cancellable)
        
        profileManager.$profile
            .sink { [weak self] profile in self?.output.profile = profile }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.settingsTap
            .sink { [weak self] _ in self?.router?.navigateToSettingsScreen() }
            .store(in: &cancellable)
        
        input.signInTap
            .sink { [weak self] _ in self?.router?.navigateToAuthorizationFlow() }
            .store(in: &cancellable)
        
        input.logOutTap
            .sink { [weak self] _ in self?.profileManager.logOut() }
            .store(in: &cancellable)
    }
}

extension ProfileViewModel {
    struct Input {
        let onAppear: PassthroughSubject<Void, Never> = .init()
        let settingsTap: PassthroughSubject<Void, Never> = .init()
        let signInTap: PassthroughSubject<Void, Never> = .init()
        let logOutTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var profile: Profile?
    }
}
