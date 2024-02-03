//
//  MoodPickerViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 16.04.2023.
//

import Foundation
import Combine

enum MoodType: String, Identifiable, CaseIterable {
  case calm = "Calm"
  case energetic = "Energetic"
  case romantic = "Romantic"
  case playful = "Playful"

  var associationColors: [String] {
    switch self {
    case .calm:
      //                return ["white", "gray", "blue", "green"]
      return ["light blue", "soft green", "lavender", "pale pink", "light gray"]
    case .energetic:
      //                return ["red", "orange", "yellow", "pink"]
      return ["bright yellow", "orange", "hot pink", "electric blue", "red"]
    case .romantic:
      //                return ["purple", "pink", "red", "blue"]
      return ["deep red", "rose pink", "lavender", "soft peach", "champagne"]
    case .playful:
      //                return ["yellow", "orange", "green", "blue"]
      return ["lime green", "turquoise", "bright purple", "sunny yellow", "coral"]
    }
  }

  var buttonText: Strings {
    switch self {
    case .calm: return .calm
    case .energetic: return .energetic
    case .romantic: return .romantic
    case .playful: return .playful
    }
  }

  var id: Int { hashValue }
}

final class MoodPickerViewModel: ObservableObject {
  let input: Input
  @Published var output: Output

  private let colorManager: ColorManager

  private var cancellable: Set<AnyCancellable> = .init()

  init() {
    self.input = Input()
    self.output = Output()

    self.colorManager = .shared

    bindMood()

    print("\(self) INIT")
  }

  deinit {
    cancellable.forEach { $0.cancel() }
    cancellable.removeAll()

    print("\(self) DEINIT")
  }
}

private extension MoodPickerViewModel {
  func bindMood() {
    input.moodSelected
      .sink { [weak self] moodType in
        guard let associatedColors = self?.colorManager.moodColors[moodType.rawValue] else { return }

        if let color = associatedColors.randomElement() {
          self?.output.color = color
        }
      }
      .store(in: &cancellable)
  }
}

extension MoodPickerViewModel {
  struct Input {
    let moodSelected: PassthroughSubject<MoodType, Never> = .init()
  }

  struct Output {
    let moods: [MoodType] = MoodType.allCases
    var color: AppColor = .getClear()
  }
}






