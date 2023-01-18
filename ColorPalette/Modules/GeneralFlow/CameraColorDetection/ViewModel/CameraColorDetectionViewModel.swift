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
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: FavoritesRoutable) {
        self.input = Input()
        self.output = Output()
        
        self.router = router
        self.favoriteManager = .shared
        
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
            .sink { [weak self] hex in
                let color = AppColor(hex: hex)
                self?.favoriteManager.addColor(color)
                self?.router?.pop()
            }
            .store(in: &cancellable)
    }
}

extension CameraColorDetectionViewModel {
    struct Input {
        let closeTap: PassthroughSubject<Void, Never> = .init()
        let addTap: PassthroughSubject<String, Never> = .init()
    }
    
    struct Output {}
}
