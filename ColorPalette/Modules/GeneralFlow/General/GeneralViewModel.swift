//
//  GeneralViewModel.swift
//  ColorPalette
//
//  Created by Кирилл Колесников on 10.02.2023.
//

import Foundation
import Combine

protocol ViewModelErrorHandleProtocol {
  func handleError(_ response: Subscribers.Completion<ApiError>)
}

extension ViewModelErrorHandleProtocol {
  func handleError(_ response: Subscribers.Completion<ApiError>) {
    switch response {
    case.failure(let apiError):
      print(apiError.localizedDescription)
    case .finished:
      print("finished")
    }
  }
}

final class GeneralViewModel: ObservableObject {
  typealias Routable = SamplesRoutable & InfoRoutable & DetectionRoutable

  let input: Input
  @Published var output: Output

  private weak var router: Routable?

  private let favoritesService: FavoritesFetchServiceProtocol
  private let profileService: ProfileServiceProtocol

  private let favoritesManager: FavoriteManager
  private let profileManager: ProfileManager

  private var cancellable: Set<AnyCancellable> = .init()

  init(
    router: Routable? = nil,
    favoritesService: FavoritesFetchServiceProtocol = FavoritesNetworkService.shared,
    profileService: ProfileServiceProtocol = AuthorizationNetworkService.shared
  ) {
    self.input = Input()
    self.output = Output()

    self.router = router
    self.favoritesService = favoritesService
    self.profileService = profileService

    self.favoritesManager = .shared
    self.profileManager = .shared

    bindRequests()
    bindTaps()

    print("\(self) INIT")
  }

  deinit {
    cancellable.forEach { $0.cancel() }
    cancellable.removeAll()

    print("\(self) DEINIT")
  }
}

private extension GeneralViewModel {
  private func bindRequests() {
    input.onAppear
      .filter { _ in !CredentialsManager.shared.isGuest }
      .flatMap { [unowned self] _ in
        profileService.fetchProfile()
      }
      .sink(
        receiveCompletion: { [unowned self] response in
          handleError(response)
        },
        receiveValue: { [unowned self] profile in
          profileManager.setProfile(profile)
        }
      )
      .store(in: &cancellable)

    input.onAppear
      .filter { _ in !CredentialsManager.shared.isGuest }
      .flatMap { [unowned self] _ -> AnyPublisher<([AppColor], [ColorPalette]), ApiError> in
        Publishers
          .Zip(
            self.favoritesService.fetchColors(),
            self.favoritesService.fetchPalettes()
          )
          .eraseToAnyPublisher()
      }
      .sink(
        receiveCompletion: { [unowned self] response in
          handleError(response)
        },
        receiveValue: { [unowned self] items in
          favoritesManager.setItemsFromServer(colors: items.0, palettes: items.1)}
      )
      .store(in: &cancellable)

    input.onAppear
      .filter { _ in CredentialsManager.shared.isGuest }
      .sink { [unowned self] _ in
        favoritesManager.setItemsFromCoreData()
      }
      .store(in: &cancellable)
  }

  private func bindTaps() {
    input.showMorePalettesTap
      .sink { [unowned self] _ in
        router?.navigateToSamplePalettes()
      }
      .store(in: &cancellable)

    input.showMoreColorsTap
      .sink { [unowned self] _ in
        router?.navigateToSampleColors()
      }
      .store(in: &cancellable)

    input.paletteTap
      .sink { [unowned self] in
        router?.navigateToColorPalette(palette: $0)
      }
      .store(in: &cancellable)

    input.colorTap
      .sink { [unowned self] in
        router?.navigateToColorInfo(color: $0)
      }
      .store(in: &cancellable)

    input.imageDetectionTap
      .sink { [unowned self] in
        router?.navigateToImageColorDetection()
      }
      .store(in: &cancellable)

    input.cameraDetectionTap
      .sink { [unowned self] in
        router?.navigateToCameraColorDetection()
      }
      .store(in: &cancellable)
  }
}

extension GeneralViewModel: ViewModelErrorHandleProtocol {
  struct Input {
    let onAppear: PassthroughSubject<Void, Never> = .init()

    let showMorePalettesTap: PassthroughSubject<Void, Never> = .init()
    let showMoreColorsTap: PassthroughSubject<Void, Never> = .init()

    let paletteTap: PassthroughSubject<ColorPalette, Never> = .init()
    let colorTap: PassthroughSubject<AppColor, Never> = .init()

    let imageDetectionTap: PassthroughSubject<Void, Never> = .init()
    let cameraDetectionTap: PassthroughSubject<Void, Never> = .init()
  }

  struct Output {
    let samplePalettes: [ColorPalette] = Array(PopularPalettesManager.shared.palettes.shuffled().prefix(5))
    let sampleColors: [AppColor] = Array(ColorManager.shared.colors.shuffled().prefix(5))
  }
}
