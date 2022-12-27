//
//  FavoriteViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import Foundation
import Combine

final class FavoriteViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private let favoriteManager: FavoriteManager
    weak private var router: FavoritesRoutable?
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: FavoritesRoutable? = nil) {
        self.input = Input()
        self.output = Output()
        self.favoriteManager = FavoriteManager.shared
        self.router = router
        
        bindFavoriteManager()
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
        
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
}

private extension FavoriteViewModel {
    func bindFavoriteManager() {
        favoriteManager.$palettes.sink { [weak self] palettes in
            self?.output.palettes = palettes
        }
        .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.addPaletteTap
            .sink { [weak self] _ in
                self?.router?.navigateToCreatePalette()
            }
            .store(in: &cancellable)
    }
}

extension FavoriteViewModel {
    func removePalette(from index: Int) {
        let paletteForDelete = output.palettes[index]
        favoriteManager.removePalette(paletteForDelete)
    }
}

extension FavoriteViewModel {
    struct Input {
        let addPaletteTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var palettes: [ColorPalette] = []
    }
}
