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

@MainActor
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
    
    characteristic.readValue()
      .receive(on: DispatchQueue.main)
      .sink { event in
        print(event)
      } receiveValue: { [weak self] data in
        self?.handleData(data)
      }.store(in: &cancellables)

    characteristic.observeValue()
      .receive(on: DispatchQueue.main)
      .sink(
        receiveCompletion: { event in
          print(event)
        },
        receiveValue: { [weak self] data in
          self?.handleData(data)
        }
      ).store(in: &cancellables)
  }
  
  private func handleData(_ data: BLEData) {
    let encodedData = data.value.base64EncodedString()
    let hexData = data.value.reduce("") { $0 + String(format: "%02x", $1) }

    self.encodedData = encodedData
    self.hexData = hexData
  }

}
