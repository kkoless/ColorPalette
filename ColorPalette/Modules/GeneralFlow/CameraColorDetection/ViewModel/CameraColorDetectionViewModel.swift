//
//  CameraColorDetectionViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 18.01.2023.
//

import Foundation
import Combine

final class CameraColorDetectionViewModel: ObservableObject {
  typealias Routable = PopRoutable & InfoRoutable
  
  let input: Input
  @Published var output: Output
  
  private weak var router: Routable?
  private let favoriteManager: FavoriteManager
  private let service: FavoritesAddServiceProtocol
  
  private var cancellable: Set<AnyCancellable> = .init()
  
  init(router: Routable? = nil,
       service: FavoritesAddServiceProtocol = FavoritesNetworkService.shared) {
    self.input = Input()
    self.output = Output()
    
    self.router = router
    self.favoriteManager = .shared
    self.service = service
    
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
  private func bindTaps() {
    input.closeTap
      .sink { [weak self] _ in
        self?.router?.pop()
      }
      .store(in: &cancellable)
    
    input.addTap
      .sink { [weak self] data in
        let color = AppColor(hex: data.0, alpha: data.1)
        self?.router?.navigateToColorInfo(color: color)
      }
      .store(in: &cancellable)
  }
}

extension CameraColorDetectionViewModel: ViewModelErrorHandleProtocol {
  struct Input {
    let closeTap: PassthroughSubject<Void, Never> = .init()
    let addTap: PassthroughSubject<(String, CGFloat), Never> = .init()
  }
  
  struct Output {}
}
