//
//  CameraColorDetectionViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 18.01.2023.
//

import Foundation
import Combine

final class CameraColorDetectionViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private weak var router: FavoritesRoutable?
    private let favoriteManager: FavoriteManager
    private let service: FavoritesAddServiceProtocol
    
    private var color: AppColor = .getClear()
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: FavoritesRoutable? = nil,
         service: FavoritesAddServiceProtocol = FavoritesNetworkService.shared) {
        self.input = Input()
        self.output = Output()
        
        self.router = router
        self.favoriteManager = .shared
        self.service = service
        
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        print("\(self) DEINIT")
    }
}

private extension CameraColorDetectionViewModel {
    func bindTaps() {
        input.closeTap
            .sink { [weak self] _ in self?.router?.pop() }
            .store(in: &cancellable)
        
        input.addTap
            .filter { _ in CredentialsManager.shared.isGuest }
            .sink { [weak self] data in
                self?.color = AppColor(hex: data.0, alpha: data.1)
                if let color = self?.color {
                    self?.favoriteManager.addColor(color)
                    self?.router?.pop()
                }
            }
            .store(in: &cancellable)
        
        input.addTap
            .filter { _ in !CredentialsManager.shared.isGuest }
            .flatMap { [unowned self] data in
                color = AppColor(hex: data.0, alpha: data.1)
                return service.addColor(color: color)
            }
            .sink(receiveCompletion: { [weak self] response in self?.handleError(response) },
                  receiveValue: { [weak self] _ in
                if let color = self?.color {
                    self?.favoriteManager.addColor(color)
                    self?.router?.pop()
                }
            })
            .store(in: &cancellable)
    }
}

extension CameraColorDetectionViewModel: ViewModelErrorHandleProtocol {
    struct Input {
        let closeTap: PassthroughSubject<Void, Never> = .init()
        let addTap: PassthroughSubject<(String, CGFloat), Never> = .init()
    }
    
    struct Output {}
}
