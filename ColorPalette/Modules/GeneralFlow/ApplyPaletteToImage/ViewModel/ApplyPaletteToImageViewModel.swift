//
//  ApplyPaletteToImageViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 22.04.2023.
//

import Foundation
import Combine

final class ApplyPaletteToImageViewModel: ObservableObject {
    typealias Routable = PopRoutable & InfoRoutable
    
    let palette: ColorPalette
    
    let input: Input
    @Published var output: Output
    
    weak private var router: Routable?
    private let service: ReplaceImageColorsServiceProtocol
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: Routable? = nil,
         palette: ColorPalette,
         service: ReplaceImageColorsServiceProtocol = GeneralNetworkService.shared) {
        self.palette = palette
        
        self.service = service
        self.router = router
        
        self.input = Input()
        self.output = Output()
        
        bindAppear()
        bindTaps()
        
        print("\(self) INIT")
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        print("\(self) DEINIT")
    }
}

private extension ApplyPaletteToImageViewModel {
    func bindAppear() {
        input.imageAppear
            .merge(with: input.tryAgainTap.combineLatest(input.imageAppear).map { $0.1 })
            .flatMap { [unowned self] data -> AnyPublisher<([AppColor], Data), ApiError> in
                self.output.resultImageData = nil
                self.output.showLoader = true
                return self.service.replaceColors(imageData: data!, palette: self.palette)
            }
            .sink { [weak self] response in
                switch response {
                    case .failure(let error):
                        self?.output.showLoader = false
                        print(error.localizedDescription)
                        
                    case .finished: print("OK")
                }
            } receiveValue: { [weak self] response in
                self?.output.showLoader = false
                self?.output.initialPalette = ColorPalette(colors: response.0)
                self?.output.resultImageData = response.1
            }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.backTap
            .sink { [weak self] _ in self?.router?.pop() }
            .store(in: &cancellable)
    }
}

extension ApplyPaletteToImageViewModel {
    struct Input {
        let imageAppear: PassthroughSubject<Data?, Never> = .init()
        let backTap: PassthroughSubject<Void, Never> = .init()
        let tryAgainTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var showLoader: Bool = false
        var initialPalette: ColorPalette? = nil
        var resultImageData: Data? = nil
    }
}
