//
//  AddNewColorToFavoritesViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.02.2023.
//

import Foundation
import Combine

final class AddNewColorToFavoritesViewModel: ObservableObject {
    
    let input: Input
    @Published var output: Output
    
    private weak var router: FavoritesRoutable?
    private let service: FavoritesAddServiceProtocol
    private let favoritesManager: FavoriteManager
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: FavoritesRoutable? = nil,
         service: FavoritesAddServiceProtocol = FavoritesNetworkService.shared) {
        self.input = Input()
        self.output = Output()
        
        self.router = router
        self.service = service
        self.favoritesManager = .shared
        
        bindColorChanges()
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        print("\(self) DEINIT")
    }
}

private extension AddNewColorToFavoritesViewModel {
    func bindColorChanges() {
        Publishers.CombineLatest(input.selectedColor, input.colorName)
            .combineLatest(favoritesManager.$colors)
            .sink { [weak self] data in
                let color = AppColor(name: data.0.1, hex: data.0.0.hex, alpha: data.0.0.alpha)
                
                self?.output.color = color
                self?.output.isFavorite = data.1.contains(where: { $0 == color }) ? true : false
            }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.addTap
            .filter { _ in CredentialsManager.shared.isGuest }
            .sink { [weak self] _ in
                if let color = self?.output.color {
                    self?.favoritesManager.addColor(color)
                    self?.output.isFavorite = true
                    self?.router?.pop()
                }
            }
            .store(in: &cancellable)
        
        input.addTap
            .filter { _ in !CredentialsManager.shared.isGuest }
            .flatMap { [unowned self] _ in service.addColor(color: output.color) }
            .sink(receiveCompletion: { [weak self] response in self?.handleError(response) },
                  receiveValue: { [weak self] _ in
                if let color = self?.output.color {
                    self?.favoritesManager.addColor(color)
                    self?.output.isFavorite = true
                    self?.router?.pop()
                }
            })
            .store(in: &cancellable)
        
        input.backTap
            .sink { [weak self] _ in self?.router?.pop() }
            .store(in: &cancellable)
    }
}

extension AddNewColorToFavoritesViewModel: ViewModelErrorHandleProtocol {
    struct Input {
        let colorName: CurrentValueSubject<String, Never> = .init("")
        let selectedColor: CurrentValueSubject<AppColor, Never> = .init(.getClear())
        let addTap: PassthroughSubject<Void, Never> = .init()
        let backTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var color: AppColor = .getClear()
        var isFavorite: Bool = false
    }
}
