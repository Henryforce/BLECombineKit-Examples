//
//  ServicesViewModel.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import Combine
import CoreBluetooth
import SwiftUI

final class ServicesViewModel: ObservableObject {
  let id = UUID()

  @Published var name = "-"
  @Published var services = [BLEService]()

  let scanResult: BLEScanResult
  let parentViewModel: DevicesViewModel

  init(scanResult: BLEScanResult, parentViewModel: DevicesViewModel) {
    self.scanResult = scanResult
    self.parentViewModel = parentViewModel
    print("ServicesViewModel init")
  }

  private var cancellables = Set<AnyCancellable>()

  func startObservingServices() {
    let peripheral = scanResult.peripheral

    name = peripheral.associatedPeripheral.name ?? "Unknown"

    peripheral.connect(with: [:])
      .first()
      .flatMap { $0.discoverServices(serviceUUIDs: nil) }
      .sink(
        receiveCompletion: { event in
          print("Services scan completed: \(event)")
        },
        receiveValue: { [weak self] service in
          guard let self = self else { return }
          self.services.append(service)
        }
      ).store(in: &cancellables)
  }

  func reset() {
    name = "-"
    cancellables.forEach { $0.cancel() }
    cancellables.removeAll()
    services.removeAll()
  }

  func serviceSelected(_ service: BLEService) {
    let viewModel = CharacteristicsViewModel(
      service: service,
      parentViewModel: parentViewModel
    )
    parentViewModel.detailScreens.append(.characteristics(viewModel))
  }
}
