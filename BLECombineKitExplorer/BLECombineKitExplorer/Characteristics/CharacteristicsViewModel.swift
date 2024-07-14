//
//  CharacteristicsViewModel.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import Combine
import Foundation

final class CharacteristicsViewModel: ObservableObject {
  let id = UUID()
  @Published var name = "-"
  @Published var characteristics = [BLECharacteristic]()
  private var cancellables = Set<AnyCancellable>()

  let service: BLEService
  let parentViewModel: DevicesViewModel

  init(service: BLEService, parentViewModel: DevicesViewModel) {
    self.service = service
    self.parentViewModel = parentViewModel

    print("CharacteristicsViewModel init")
  }

  func startObservingCharacteristics() {
    reset()

    name = service.value.uuid.uuidString

    service.discoverCharacteristics(characteristicUUIDs: [])
      .sink(
        receiveCompletion: { event in
          print("Characteristics scan completed: \(event)")
        },
        receiveValue: { [weak self] characteristic in
          guard let self = self else { return }
          self.characteristics.append(characteristic)
        }
      ).store(in: &cancellables)
  }

  func reset() {
    name = "-"
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    characteristics.removeAll()
  }

  func selectCharacteristic(_ characteristic: BLECharacteristic) {
    let viewModel = CharacteristicDetailViewModel(
      characteristic: characteristic,
      parentViewModel: parentViewModel
    )
    parentViewModel.detailScreens.append(.characteristicDetails(viewModel))
  }

}
