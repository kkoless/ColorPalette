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
    private weak var router: ProfileRoutable?
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: ProfileRoutable? = nil) {
        self.input = Input()
        self.output = Output()
        self.router = router
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
        profileManager.$profile
            .sink { [weak self] profile in self?.output.profile = profile }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.signInTap
            .sink { [weak self] _ in self?.router?.navigateToAuthorizationFlow() }
            .store(in: &cancellable)
        
        input.changeRoleTap
            .sink { [weak self] _ in self?.profileManager.changeRole() }
            .store(in: &cancellable)
        
        input.logOutTap
            .sink { [weak self] _ in self?.profileManager.logOut() }
            .store(in: &cancellable)
    }
}

extension ProfileViewModel {
    struct Input {
        let signInTap: PassthroughSubject<Void, Never> = .init()
        let changeRoleTap: PassthroughSubject<Void, Never> = .init()
        let logOutTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var profile: Profile?
    }
}
