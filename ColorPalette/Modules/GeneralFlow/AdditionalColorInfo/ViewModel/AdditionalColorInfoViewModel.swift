//
//  AdditionalColorInfoViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 11.04.2023.
//

import Foundation
import Combine

final class AdditionalColorInfoViewModel: ObservableObject {
    typealias Routable = PopRoutable
    
    let color: AppColor
    let input: Input
    @Published var output: Output
    
    private weak var router: Routable?
    private let service: GoogleSearchNetworkService
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    
    init(color: AppColor,
         service: GoogleSearchNetworkService = .shared,
         router: Routable? = nil) {
        self.color = color
        
        self.input = Input()
        self.output = Output()
        
        self.router = router
        self.service = service
        
        bindAppear()
        bindTaps()
        
        print("INIT \(self)")
    }
    
    deinit {
        cancellable.forEach { $0.cancel() }
        cancellable.removeAll()
        
        print("DEINIT \(self)")
    }
}

private extension AdditionalColorInfoViewModel {
    func bindAppear() {
        input.onAppear
            .flatMap { [unowned self] _ -> AnyPublisher<GoogleSearchResponse, ApiError> in
                self.service.search(dominantColor: self.color)
            }
            .sink { response in
                switch response {
                    case.failure(let apiError):
                        print(apiError.localizedDescription)
                    case .finished:
                        print("finished")
                }
            } receiveValue: { [weak self] response in
                self?.output.imageUrls = response.items?
                    .compactMap { $0.pagemap }
                    .compactMap { $0.cseImage }
                    .compactMap { $0.compactMap { $0.src }.first }
                    .compactMap { URL(string: $0) } ?? []
            }
            .store(in: &cancellable)
    }
    
    func bindTaps() {
        input.backTap
            .sink { [weak self] _ in self?.router?.pop() }
            .store(in: &cancellable)
    }
}

extension AdditionalColorInfoViewModel {
    struct Input {
        let onAppear: PassthroughSubject<Void, Never> = .init()
        let backTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        var imageUrls: [URL] = []
    }
}
