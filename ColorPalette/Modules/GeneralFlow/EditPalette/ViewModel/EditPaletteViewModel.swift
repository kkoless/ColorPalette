//
//  EditPaletteViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 15.02.2023.
//

import Foundation
import Combine

final class EditPaletteViewModel: ObservableObject {
  typealias Routable = PopRoutable
  let initPalette: ColorPalette

  let input: Input
  @Published var output: Output

  private weak var router: Routable?
  private let service: FavoritesUpdateServiceProtocol
  private let favoriteManager: FavoriteManager

  private var cancellable: Set<AnyCancellable> = .init()

  init(
    service: FavoritesUpdateServiceProtocol = FavoritesNetworkService.shared,
    router: Routable? = nil,
    palette: ColorPalette
  ) {
    self.initPalette = palette

    self.input = Input()
    self.output = Output(
      initPaletteColors: palette.colors,
      resultPaletteColors: palette.colors
    )

    self.router = router
    self.service = service
    self.favoriteManager = .shared

    bindTaps()

    print("\(self) INIT")
  }

  deinit {
    cancellable.forEach { $0.cancel() }
    cancellable.removeAll()

    print("\(self) DEINIT")
  }
}

private extension EditPaletteViewModel {
  func bindTaps() {
    input.updateTap
      .filter { _ in !CredentialsManager.shared.isGuest }
      .flatMap { [unowned self] _ -> AnyPublisher<Void, ApiError> in
        let newPalette = ColorPalette(colors: self.output.resultPaletteColors)
        return self.service.updatePalette(
          paletteId: self.initPalette.id,
          newPalette: newPalette
        )
      }
      .sink(
        receiveCompletion: { [weak self] response in self?.handleError(response) },
        receiveValue: { [weak self] _ in
          if let newColors = self?.output.resultPaletteColors,
             let initPalette = self?.initPalette {
            self?.favoriteManager.updatePalette(
              paletteForDelete: initPalette,
              newPalette: ColorPalette(colors: newColors)
            )
            self?.router?.pop()
          }
        }
      )
      .store(in: &cancellable)

    input.updateTap
      .filter { _ in CredentialsManager.shared.isGuest }
      .sink { [weak self] newPalette in
        if let newColors = self?.output.resultPaletteColors,
           let initPalette = self?.initPalette {
          self?.favoriteManager.updatePalette(
            paletteForDelete: initPalette,
            newPalette: ColorPalette(colors: newColors)
          )
          self?.router?.pop()
        }
      }
      .store(in: &cancellable)

    input.resetTap
      .sink { [weak self] _ in
        if let colors = self?.initPalette.colors {
          self?.output.initPaletteColors = colors
          self?.output.resultPaletteColors = colors
        }
      }
      .store(in: &cancellable)

    input.backTap
      .sink { [weak self] _ in self?.router?.pop() }
      .store(in: &cancellable)
  }
}

extension EditPaletteViewModel {
  func sliderChangeHSB(hue: CGFloat, saturation: CGFloat, brightness: CGFloat) {
    DispatchQueue.global().async { [weak self] in
      let colors = self?.output.initPaletteColors.map { $0.uiColor } ?? []

      let newColors = colors.map {
        AppColor(
          uiColor: $0.add(
            hue: hue,
            saturation: saturation,
            brightness: brightness,
            alpha: $0.alphaValue
          )
        )
      }

      DispatchQueue.main.async {
        self?.output.resultPaletteColors = newColors
      }
    }
  }
}

extension EditPaletteViewModel: ViewModelErrorHandleProtocol {
  struct Input {
    let backTap: PassthroughSubject<Void, Never> = .init()
    let updateTap: PassthroughSubject<Void, Never> = .init()
    let resetTap: PassthroughSubject<Void, Never> = .init()
  }

  struct Output {
    var initPaletteColors: [AppColor]
    var resultPaletteColors: [AppColor]
  }
}
