//
//  CharacteristicsDetailViewModel.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import Combine
import CoreBluetooth
import Foundation
import SwiftUI

final class CharacteristicDetailViewModel: ObservableObject {
  let id = UUID()
  @Published var name = "-"
  @Published var encodedData = "-"
  @Published var hexData = "-"
  private var cancellables = Set<AnyCancellable>()

  let characteristic: BLECharacteristic
  let parentViewModel: DevicesViewModel

  init(characteristic: BLECharacteristic, parentViewModel: DevicesViewModel) {
    self.characteristic = characteristic
    self.parentViewModel = parentViewModel
  }

  func setup() {
    name = characteristic.value.uuid.uuidString
  }

  func readValue() {
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()

    characteristic.observeValue()
      .receive(on: RunLoop.main)
      .sink(
        receiveCompletion: { event in
          print(event)
        },
        receiveValue: { [weak self] data in
          guard let self = self else { return }
          let encodedData = data.value.base64EncodedString()
          let hexData = data.value.reduce("") { $0 + String(format: "%02x", $1) }

          self.encodedData = encodedData
          self.hexData = hexData
        }
      ).store(in: &cancellables)
  }

}
