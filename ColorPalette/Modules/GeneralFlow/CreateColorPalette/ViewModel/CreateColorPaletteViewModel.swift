//
//  CreateColorPaletteViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import Foundation
import Combine

final class CreateColorPaletteViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    let templatePaletteManager: TemplatePaletteManager
    private let favoriteManager: FavoriteManager
    
    weak private var router: FavoritesRoutable?
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: FavoritesRoutable? = nil) {
        self.templatePaletteManager = .init()
        self.favoriteManager = FavoriteManager.shared
        self.input = Input()
        self.output = Output()
        self.router = router
        
        bindTemplateManager()
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
        
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
}

private extension CreateColorPaletteViewModel {
    func bindTemplateManager() {
        templatePaletteManager.$colors
            .sink { [weak self] colors in self?.output.colors = colors }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.saveTap
            .sink { [weak self] _ in
                self?.savePalette()
                self?.router?.pop()
            }
            .store(in: &cancellable)
        
        input.backTap
            .sink { [weak self] _ in self?.output.showSaveAlert.toggle() }
            .store(in: &cancellable)
        
        input.stayAlertTap
            .sink { [weak self] _ in self?.output.showSaveAlert.toggle() }
            .store(in: &cancellable)
        
        input.backAlertTap
            .sink { [weak self] _ in self?.router?.pop() }
            .store(in: &cancellable)
    }
}

private extension CreateColorPaletteViewModel {
    func savePalette() {
        let palette = templatePaletteManager.createPalette()
        favoriteManager.addPalette(palette)
    }
}

extension CreateColorPaletteViewModel {
    struct Input {
        let saveTap: PassthroughSubject<Void, Never> = .init()
        let backTap: PassthroughSubject<Void, Never> = .init()
        let stayAlertTap: PassthroughSubject<Void, Never> = .init()
        let backAlertTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var colors: [AppColor] = []
        var showSaveAlert: Bool = false
    }
}
