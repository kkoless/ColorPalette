//
//  ImageColorDetectionViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 28.12.2022.
//

import Foundation
import Combine

final class ImageColorDetectionViewModel: ObservableObject {
    typealias Routable = PopRoutable & InfoRoutable
    
    let input: Input
    @Published var output: Output
    
    weak private var router: Routable?
    private let manager: ImageColorDetectionManager
    private let favoriteManager: FavoriteManager
    private let service: FavoritesAddServiceProtocol
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: Routable? = nil,
         service: FavoritesAddServiceProtocol = FavoritesNetworkService.shared) {
        self.manager = ImageColorDetectionManager()
        self.favoriteManager = FavoriteManager.shared
        self.service = service
        
        self.router = router
        
        self.input = Input()
        self.output = Output(isLimit: self.favoriteManager.isPalettesLimit)
        
        bindFavoriteManager()
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
    func bindFavoriteManager() {
        favoriteManager.$isPalettesLimit
            .sink { [weak self] flag in self?.output.isLimit = flag }
            .store(in: &cancellable)
        
        favoriteManager.$palettes
            .combineLatest(manager.$palette) { (favoritePalettes: $0, palette: $1) }
            .sink { [weak self] data in
                self?.output.isFavorire = data.favoritePalettes.contains(where: { $0 == data.palette }) ? true : false
            }
            .store(in: &cancellable)
    }
    
    func bindDetection() {
        input.imageAppear
            .sink { [weak self] imageData in
                guard let data = imageData else { return }
                self?.manager.generatePalette(from: data)
            }
            .store(in: &cancellable)
        
        manager.$palette
            .combineLatest(favoriteManager.$palettes) { (favoritePalettes: $1, palette: $0) }
            .sink { [weak self] data in
                self?.output.palette = data.palette
                
                if data.favoritePalettes.contains(where: { $0 == data.palette }) {
                    self?.output.isFavorire = true
                }
            }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.backTap
            .sink { [weak self] _ in self?.router?.pop() }
            .store(in: &cancellable)
        
        input.imageTap
            .sink { [weak self] imageData in self?.router?.pop() }
            .store(in: &cancellable)
        
        input.addToFavoriteTap
            .filter { _ in CredentialsManager.shared.isGuest }
            .sink { [weak self] palette in
                self?.favoriteManager.addPalette(palette)
                self?.router?.pop()
            }
            .store(in: &cancellable)
        
        input.addToFavoriteTap
            .filter { _ in !CredentialsManager.shared.isGuest }
            .flatMap { [unowned self] palette in service.addPalette(palette: palette) }
            .sink(receiveCompletion: { [weak self] response in self?.handleError(response) },
                  receiveValue: { [weak self] palette in
                if let palette = self?.output.palette {
                    self?.favoriteManager.addPalette(palette)
                    self?.router?.pop()
                }
            })
            .store(in: &cancellable)
        
        input.showPaletteTap
            .sink { [weak self] palette in self?.router?.navigateToColorPalette(palette: palette) }
            .store(in: &cancellable)
    }
}

extension ImageColorDetectionViewModel: ViewModelErrorHandleProtocol {
    struct Input {
        let imageAppear: PassthroughSubject<Data?, Never> = .init()
        let addToFavoriteTap: PassthroughSubject<ColorPalette, Never> = .init()
        let showPaletteTap: PassthroughSubject<ColorPalette, Never> = .init()
        let backTap: PassthroughSubject<Void, Never> = .init()
        let imageTap: PassthroughSubject<Data?, Never> = .init()
    }
    
    struct Output {
        var palette: ColorPalette?
        var isLimit: Bool
        var isFavorire: Bool = false
    }
}
