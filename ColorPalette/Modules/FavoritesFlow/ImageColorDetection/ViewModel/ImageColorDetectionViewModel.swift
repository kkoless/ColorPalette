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

  private weak var router: Routable?
  private let manager: ImageColorDetectionManager
  private let favoriteManager: FavoriteManager
  private let service: FavoritesAddServiceProtocol

  private var cancellable: Set<AnyCancellable> = .init()

  init(
    router: Routable? = nil,
    service: FavoritesAddServiceProtocol = FavoritesNetworkService.shared
  ) {
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

private extension ImageColorDetectionViewModel {
  private func bindFavoriteManager() {
    favoriteManager.$isPalettesLimit
      .sink { [unowned self] flag in
        output.isLimit = flag
      }
      .store(in: &cancellable)

    favoriteManager.$palettes
      .combineLatest(manager.$palette) { (favoritePalettes: $0, palette: $1) }
      .sink { [unowned self] data in
        output.isFavorire = data.favoritePalettes.contains(where: { $0 == data.palette }) ? true : false
      }
      .store(in: &cancellable)
  }

  private func bindDetection() {
    input.imageAppear
      .sink { [unowned self] imageData in
        guard let data = imageData else { return }
        manager.generatePalette(from: data)
      }
      .store(in: &cancellable)

    manager.$palette
      .combineLatest(favoriteManager.$palettes) { (favoritePalettes: $1, palette: $0) }
      .sink { [unowned self] data in
        output.palette = data.palette

        if data.favoritePalettes.contains(where: { $0 == data.palette }) {
          output.isFavorire = true
        }
      }
      .store(in: &cancellable)
  }

  private func bindTaps() {
    input.backTap
      .sink { [unowned self] _ in
        router?.pop()
      }
      .store(in: &cancellable)

    input.imageTap
      .sink { [unowned self] imageData in
        router?.pop()
      }
      .store(in: &cancellable)

    input.addToFavoriteTap
      .filter { _ in CredentialsManager.shared.isGuest }
      .sink { [unowned self] palette in
        favoriteManager.addPalette(palette)
        router?.pop()
      }
      .store(in: &cancellable)

    input.addToFavoriteTap
      .filter { _ in !CredentialsManager.shared.isGuest }
      .flatMap { [unowned self] palette in
        service.addPalette(palette: palette)
      }
      .sink(
        receiveCompletion: { [unowned self] response in
          handleError(response)
        },
        receiveValue: { [unowned self] palette in
          if let palette = output.palette {
            favoriteManager.addPalette(palette)
            router?.pop()
          }
        })
      .store(in: &cancellable)

    input.showPaletteTap
      .sink { [unowned self] palette in
        router?.navigateToColorPalette(palette: palette)
      }
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
