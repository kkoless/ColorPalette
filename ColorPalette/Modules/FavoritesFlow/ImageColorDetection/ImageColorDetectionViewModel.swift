//
//  ImageColorDetectionViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 28.12.2022.
//

import Foundation
import Combine

final class ImageColorDetectionViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    weak private var router: FavoritesRoutable?
    private var manager: ImageColorDetectionManager
    private var favoriteManager: FavoriteManager
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: FavoritesRoutable? = nil) {
        self.manager = ImageColorDetectionManager()
        self.favoriteManager = FavoriteManager.shared
        self.input = Input()
        self.output = Output()
        self.router = router
        
        bindDetection()
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
        
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
}

extension ImageColorDetectionViewModel {
    func bindDetection() {
        input.imageAppear
            .sink { [weak self] imageData in
                guard let data = imageData else { return }
                self?.manager.generatePalette(from: data)
            }
            .store(in: &cancellable)
        
        manager.$palette
            .sink { [weak self] palette in
                self?.output.palette = palette
            }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.addToFavoriteTap
            .sink { [weak self] palette in
                self?.favoriteManager.addPalette(palette)
            }
            .store(in: &cancellable)
    }
}

private extension ImageColorDetectionViewModel {
}

extension ImageColorDetectionViewModel {
    struct Input {
        let imageAppear: PassthroughSubject<Data?, Never> = .init()
        let addToFavoriteTap: PassthroughSubject<ColorPalette, Never> = .init()
    }
    
    struct Output {
        var palette: ColorPalette? = nil
    }
}
