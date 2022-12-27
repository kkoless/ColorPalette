//
//  SampleColorsViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import Foundation
import Combine

final class SampleColorsViewModel: ObservableObject {
    let input: Input
    @Published var output: Output
    
    private weak var router: GeneralRoutable?
    private let colors = ColorManager.shared.colors
    private var anyCancellable: Set<AnyCancellable> = .init()
    
    init(router: GeneralRoutable? = nil) {
        self.router = router
        self.input = Input()
        self.output = Output()
        
        bindSearch()
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        print("\(self) DEINIT")
    }
}

private extension SampleColorsViewModel {
    func bindSearch() {
        input.searchText
            .sink { [weak self] searchText in
                if let newColors = self?.getColors(searchText) {
                    self?.output.colors = newColors
                }
            }
            .store(in: &anyCancellable)
    }
    
    func bindTaps() {
        input.infoTap
            .sink { [weak self] appColor in
                self?.router?.navigateToSimilarColors(color: appColor)
            }
            .store(in: &anyCancellable)
        
        input.colorTap
            .sink { [weak self] appColor in
                self?.router?.navigateToColorInfo(color: appColor)
            }
            .store(in: &anyCancellable)
        
        input.popTap
            .sink { [weak self] _ in
                self?.router?.pop()
            }
            .store(in: &anyCancellable)
    }
}

private extension SampleColorsViewModel {
    func getColors(_ searchText: String) -> [AppColor] {
        return searchText.isEmpty
        ? self.colors
        : self.colors.filter { $0.name.contains(searchText) }
    }
}

extension SampleColorsViewModel {
    struct Input {
        let searchText: CurrentValueSubject<String, Never> = .init("")
        let infoTap: PassthroughSubject<AppColor, Never> = .init()
        let colorTap: PassthroughSubject<AppColor, Never> = .init()
        let popTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var colors: [AppColor] = ColorManager.shared.colors
    }
}
