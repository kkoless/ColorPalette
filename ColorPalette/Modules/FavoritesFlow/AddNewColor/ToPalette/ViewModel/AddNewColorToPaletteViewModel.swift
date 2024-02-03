//
//  AddNewColorToPaletteViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 28.12.2022.
//

import Foundation
import Combine

final class AddNewColorToPaletteViewModel: ObservableObject {
  typealias Routable = DismissRoutable

  let input: Input
  @Published var output: Output

  private var templatePaletteManager: TemplatePaletteManager
  private weak var router: Routable?

  private var cancellable: Set<AnyCancellable> = .init()

  init(
    templatePaletteManager: TemplatePaletteManager,
    router: Routable? = nil
  ) {
    self.templatePaletteManager = templatePaletteManager
    self.input = Input()
    self.output = Output()
    self.router = router

    bindColorChanges()
    bindTaps()

    print("\(self) INIT")
  }

  deinit {
    print("\(self) DEINT")

    cancellable.forEach { $0.cancel() }
    cancellable.removeAll()
  }
}

private extension AddNewColorToPaletteViewModel {
  private func bindColorChanges() {
    Publishers.CombineLatest(input.selectedColor, input.colorName)
      .sink { [weak self] data in
        self?.output.color = AppColor(name: data.1, hex: data.0.hex, alpha: data.0.alpha)
      }
      .store(in: &cancellable)
  }

  private func bindTaps() {
    input.addTap
      .sink { [weak self] _ in
        self?.addColorToTemplatePalette()
        self?.router?.dismiss()
      }
      .store(in: &cancellable)
  }
}

private extension AddNewColorToPaletteViewModel {
  private func addColorToTemplatePalette() {
    let appColor = output.color
    templatePaletteManager.addColor(appColor)
  }
}

extension AddNewColorToPaletteViewModel {
  struct Input {
    let colorName: CurrentValueSubject<String, Never> = .init("")
    let selectedColor: CurrentValueSubject<AppColor, Never> = .init(.getClear())
    let addTap: PassthroughSubject<Void, Never> = .init()
  }

  struct Output {
    var color: AppColor = .getClear()
  }
}
