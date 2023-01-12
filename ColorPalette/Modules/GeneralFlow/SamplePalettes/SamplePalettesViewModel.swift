//
//  SamplePalettesViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 01.01.2023.
//

import Foundation
import Combine

final class SamplePalettesViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private weak var router: GeneralRoutable?
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: GeneralRoutable? = nil) {
        self.router = router
        self.input = Input()
        self.output = Output()
        
        bindActions()
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
        
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
    }
}

private extension SamplePalettesViewModel {
    func bindActions() {
        input.onAppear
            .sink { [weak self] _ in
                guard let self = self else { return }
                self.output.palettes = Array(PopularPalettesManager.shared.palettes
                    .prefix(self.checkLimit()))
            }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.paletteTap
            .sink { [weak self] palette in
                self?.router?.navigateToColorPalette(palette: palette)
            }
            .store(in: &cancellable)
    }
}

private extension SamplePalettesViewModel {
    func checkLimit() -> Int {
        let firstCondition = CredentialsManager.shared.isGuest
        let secondCondition = ProfileManager.shared.profile?.isFree ?? false
        
        return firstCondition || secondCondition ? 20 : 100
    }
}

extension SamplePalettesViewModel {
    struct Input {
        let onAppear: PassthroughSubject<Void, Never> = .init()
        let paletteTap: PassthroughSubject<ColorPalette, Never> = .init()
    }
    
    struct Output {
        var palettes: [ColorPalette] = .init()
    }
}
