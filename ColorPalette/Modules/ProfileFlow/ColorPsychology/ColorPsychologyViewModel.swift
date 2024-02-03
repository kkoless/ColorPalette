//
//  ColorPsychologyViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 18.04.2023.
//

import Foundation
import Combine

final class ColorPsychologyViewModel: ObservableObject {
  typealias Routable = PopRoutable & InfoRoutable

  let input: Input
  @Published var output: Output

  private weak var router: Routable?

  private var cancellable: Set<AnyCancellable> = .init()

  init(router: Routable? = nil) {
    self.input = Input()
    self.output = Output()

    self.router = router

    bindTaps()

    print("\(self) INIT")
  }

  deinit {
    cancellable.forEach { $0.cancel() }
    cancellable.removeAll()

    print("\(self) DEINIT")
  }
}

private extension ColorPsychologyViewModel {
  private func bindTaps() {
    input.backTap
      .sink { [unowned self] _ in
        router?.pop()
      }
      .store(in: &cancellable)

    input.colorTap
      .sink { [unowned self] color in
        router?.navigateToColorInfo(color: color)
      }
      .store(in: &cancellable)
  }
}

extension ColorPsychologyViewModel {
  struct Input {
    let backTap: PassthroughSubject<Void, Never> = .init()
    let colorTap: PassthroughSubject<AppColor, Never> = .init()
  }

  struct Output {

  }
}
