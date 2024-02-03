//
//  SampleColorsViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 27.12.2022.
//

import Foundation
import Combine

final class SampleColorsViewModel: ObservableObject {
  typealias Routable = PopToRootRoutable & InfoRoutable

  let input: Input
  @Published var output: Output

  private weak var router: Routable?
  private let colors = ColorManager.shared.colors
  private var cancellable: Set<AnyCancellable> = .init()

  init(router: Routable? = nil) {
    self.router = router
    self.input = Input()
    self.output = Output()

    bindSearch()
    bindTaps()

    print("\(self) INIT")
  }

  deinit {
    print("\(self) DEINIT")

    cancellable.forEach { $0.cancel() }
    cancellable.removeAll()
  }
}

private extension SampleColorsViewModel {
  private func bindSearch() {
    input.searchText
      .sink { [unowned self] searchText in
        output.colors = getColors(searchText)
      }
      .store(in: &cancellable)
  }

  private func bindTaps() {
    input.colorTap
      .sink { [unowned self] appColor in
        router?.navigateToColorInfo(color: appColor)
      }
      .store(in: &cancellable)

    input.popTap
      .sink { [unowned self] _ in
        router?.popToRoot()
      }
      .store(in: &cancellable)
  }
}

private extension SampleColorsViewModel {
  private func getColors(_ searchText: String) -> [AppColor] {
    return searchText.isEmpty
    ? self.colors
    : self.colors.filter { $0.name.contains(searchText) }
  }
}

extension SampleColorsViewModel {
  struct Input {
    let searchText: CurrentValueSubject<String, Never> = .init("")
    let colorTap: PassthroughSubject<AppColor, Never> = .init()
    let popTap: PassthroughSubject<Void, Never> = .init()
  }

  struct Output {
    var colors: [AppColor] = ColorManager.shared.colors
  }
}
