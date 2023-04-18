//
//  ProfileViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 31.12.2022.
//

import Foundation
import Combine

final class ProfileViewModel: ObservableObject {
    typealias Routable = AuthorizationRoutable & ColorPsychologyRoutable
    
    let input: Input
    @Published var output: Output
    
    private let profileManager: ProfileManager
    private let service: ProfileServiceProtocol
    private weak var router: Routable?
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: Routable? = nil,
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
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
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
            .sink { [weak self] response in
                switch response {
                    case.failure(let apiError):
                        print(apiError.localizedDescription)
                        self?.profileManager.logOut()
                        self?.output.email = ""
                        self?.output.role = .free
                    case .finished:
                        print("finished")
                }
            } receiveValue: { [weak self] profile in
                self?.profileManager.setProfile(profile)
            }
            .store(in: &cancellable)
        
        profileManager.$profile
            .sink { [weak self] profile in
                self?.output.email = profile?.email ?? ""
                self?.output.role = profile?.role ?? .free
            }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.languageTap
            .sink { language in LocalizationService.shared.language = language }
            .store(in: &cancellable)
        
        input.colorPsychologyTap
            .sink { [weak self] _ in self?.router?.navigateToColorPsychologyScreen() }
            .store(in: &cancellable)
        
        input.signInTap
            .sink { [weak self] _ in self?.router?.navigateToAuthorizationScreen() }
            .store(in: &cancellable)
        
        input.logOutTap
            .sink { [weak self] _ in self?.profileManager.logOut() }
            .store(in: &cancellable)
    }
}

extension ProfileViewModel {
    struct Input {
        let onAppear: PassthroughSubject<Void, Never> = .init()
        
        let languageTap: PassthroughSubject<Language, Never> = .init()
        let colorPsychologyTap: PassthroughSubject<Void, Never> = .init()
        
        let signInTap: PassthroughSubject<Void, Never> = .init()
        let logOutTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var email: String = ""
        var role: Role = .free
        var language: Language = LocalizationService.shared.language
    }
}
