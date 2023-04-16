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
    
    var id: Int { hashValue }
}

final class MoodPickerViewModel: ObservableObject {
    typealias Router = PopRoutable
    
    let input: Input
    @Published var output: Output
    
    private let colorManager: ColorManager
    private weak var router: Router?
    
    private var cancellable: Set<AnyCancellable> = .init()
    
    init(router: Router? = nil) {
        self.input = Input()
        self.output = Output()
        
        self.colorManager = .shared
        self.router = router
        
        bindTaps()
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
    func bindTaps() {
        input.backTap
            .sink { [weak self] _ in self?.router?.pop() }
            .store(in: &cancellable)
    }
    
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
        let backTap: PassthroughSubject<Void, Never> = .init()
    }
    
    struct Output {
        let moods: [MoodType] = MoodType.allCases
        var color: AppColor = .getClear()
    }
}






