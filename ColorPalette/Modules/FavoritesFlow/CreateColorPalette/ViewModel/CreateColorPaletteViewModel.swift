//
//  CreateColorPaletteViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import Foundation
import Combine

final class CreateColorPaletteViewModel: ObservableObject {
    typealias Routable = PopRoutable & AddRoutable
     
    let input: Input
    @Published var output: Output
    
    let templatePaletteManager: TemplatePaletteManager
    private let favoriteManager: FavoriteManager
    private let service: FavoritesAddServiceProtocol
    
    weak private var router: Routable?
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: Routable? = nil,
         service: FavoritesAddServiceProtocol = FavoritesNetworkService.shared) {
        self.templatePaletteManager = .init()
        self.favoriteManager = FavoriteManager.shared
        self.service = service
        
        self.input = Input()
        self.output = Output(colors: self.templatePaletteManager.colors,
                             isLimit: self.templatePaletteManager.isLimit)
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
        
        templatePaletteManager.$isLimit
            .sink { [weak self] flag in self?.output.isLimit = flag }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.saveTap
            .sink { [weak self] _ in
                self?.savePalette()
                self?.router?.pop()
            }
            .store(in: &cancellable)
        
        input.addTaps.addColorTap
            .sink { [weak self] _ in
                if let manager = self?.templatePaletteManager {
                    self?.router?.navigateToAddNewColorToPalette(templateManager: manager)
                }
            }
            .store(in: &cancellable)
        
        input.backTap
            .sink { [weak self] _ in
                if let colors = self?.templatePaletteManager.colors, colors.isEmpty {
                    self?.router?.pop()
                } else {
                    self?.output.showSaveAlert.toggle()
                }
            }
            .store(in: &cancellable)
        
        input.alertTaps.stayTap
            .sink { [weak self] _ in self?.output.showSaveAlert.toggle() }
            .store(in: &cancellable)
        
        input.alertTaps.backTap
            .sink { [weak self] _ in self?.router?.pop() }
            .store(in: &cancellable)
    }
}

extension CreateColorPaletteViewModel {
    func removeColor(from index: Int) {
        templatePaletteManager.deleteColor(output.colors[index])
    }
    
    func replaceColors(fromOffsets: IndexSet, toOffset: Int) {
        templatePaletteManager.replaceColors(fromOffsets: fromOffsets, toOffset: toOffset)
    }
}

private extension CreateColorPaletteViewModel {
    func savePalette() {
        let palette = templatePaletteManager.createPalette()
        let isGuest = Just(CredentialsManager.shared.isGuest)
        
        isGuest
            .filter { $0 }
            .sink { [weak self] _ in self?.favoriteManager.addPalette(palette) }
            .store(in: &cancellable)
        
        isGuest
            .filter { !$0 }
            .flatMap { [unowned self] _ in service.addPalette(palette: palette) }
            .sink(receiveCompletion: { [weak self] response in self?.handleError(response) },
                  receiveValue: { [weak self] _ in self?.favoriteManager.addPalette(palette) })
            .store(in: &cancellable)
    }
}

extension CreateColorPaletteViewModel: ViewModelErrorHandleProtocol {
    struct Input {
        let alertTaps = AlertTap()
        let addTaps = AddTap()
        
        let backTap: PassthroughSubject<Void, Never> = .init()
        let saveTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var colors: [AppColor]
        var isLimit: Bool
        var showSaveAlert: Bool = false
    }
}

extension CreateColorPaletteViewModel.Input {
    struct AddTap {
        let addColorTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct AlertTap {
        let stayTap: PassthroughSubject<Void, Never> = .init()
        let backTap: PassthroughSubject<Void, Never> = .init()
    }
}
