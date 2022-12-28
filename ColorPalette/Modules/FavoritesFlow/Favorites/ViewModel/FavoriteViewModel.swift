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
        
        favoriteManager.$colors.sink { [weak self] colors in
            self?.output.colors = colors
        }
        .store(in: &cancellable)
    }
    
    func bindTaps() {
        bindAddTaps()
        bindShowTaps()
    }
}

private extension FavoriteViewModel {
    func bindAddTaps() {
        input.addTaps.createPaletteTap
            .sink { [weak self] _ in
                self?.router?.navigateToCreatePalette()
            }
            .store(in: &cancellable)
        
        input.addTaps.generatePaletteFromImageTap
            .sink { [weak self] _ in
                self?.router?.navigateToImageColorDetection()
            }
            .store(in: &cancellable)
    }
    
    func bindShowTaps() {
        input.showTaps.showColorInfoTap
            .sink { [weak self] appColor in
                self?.router?.navigateToColorInfo(color: appColor)
            }
            .store(in: &cancellable)
        
        input.showTaps.showPaletteInfoTap
            .sink { [weak self] palette in
                self?.router?.navigateToColorPalette(palette: palette)
            }
            .store(in: &cancellable)
    }
}

extension FavoriteViewModel {
    func removePalette(from index: Int) {
        let paletteForDelete = output.palettes[index]
        favoriteManager.removePalette(paletteForDelete)
    }
    
    func removeColor(from index: Int) {
        let colorForDelete = output.colors[index]
        favoriteManager.removeColor(colorForDelete)
    }
}

extension FavoriteViewModel {
    struct Input {
        let addTaps: AddTap = .init()
        let showTaps: ShowTap = .init()
        
        struct AddTap {
            let createPaletteTap: PassthroughSubject<Void, Never> = .init()
            let choosePaletteTap: PassthroughSubject<Void, Never> = .init()
            let generatePaletteFromImageTap: PassthroughSubject<Void, Never> = .init()
            let createColorTap: PassthroughSubject<Void, Never> = .init()
            let chooseColorTap: PassthroughSubject<Void, Never> = .init()
        }
        
        struct ShowTap {
            let showColorInfoTap: PassthroughSubject<AppColor, Never> = .init()
            let showPaletteInfoTap: PassthroughSubject<ColorPalette, Never> = .init()
        }
    }
    
    struct Output {
        var palettes: [ColorPalette] = []
        var colors: [AppColor] = []
    }
}
