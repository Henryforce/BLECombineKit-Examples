//
//  DevicesViewModel.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import Combine
import CoreBluetooth
import SwiftUI

final class DevicesViewModel: ObservableObject {

  @Published var peripherals = [ScannedPeripheralItem]()
  @Published var blePeripheralMap: [UUID: BLEScanResult] = [:]

  var scanResult: BLEScanResult?
  @Published var selectedServiceViewModel: ServicesViewModel?
  @Published var selectedCharacteristicViewModel: CharacteristicsViewModel?
  @Published var detailScreens = [BLEExplorerScreen]()

  private let centralManager: BLECentralManager
  private var scanForPeripheralsCancellable: AnyCancellable?
  private var peripheralMap: [UUID: ScannedPeripheralItem] = [:]
  private var localPeripherals = [ScannedPeripheralItem]()
  private var canUpdate = true

  init(centralManager: BLECentralManager) {
    self.centralManager = centralManager
  }

  func startScanning() {
    scanForPeripheralsCancellable?.cancel()
    scanForPeripheralsCancellable =
      centralManager
      .scanForPeripherals(withServices: nil, options: nil)
      .sink(
        receiveCompletion: { completion in
          print(completion)
        },
        receiveValue: { [weak self] scanResult in
          guard let self = self, self.canUpdate else { return }

          let identifier = scanResult.peripheral.associatedPeripheral.identifier

          self.blePeripheralMap[identifier] = scanResult

          let scannedPeripheralItem = ScannedPeripheralItem(
            rssi: scanResult.rssi.doubleValue,
            name: scanResult.peripheral.associatedPeripheral.name ?? "Unknown",
            identifier: scanResult.peripheral.associatedPeripheral.identifier
          )

          if let savedPeripheral = self.peripheralMap[identifier] {
            if savedPeripheral.rssi != scannedPeripheralItem.rssi {
              self.peripheralMap.updateValue(scannedPeripheralItem, forKey: identifier)
              self.peripherals = self.peripheralMap.values.map { $0 }.sorted { $0.rssi > $1.rssi }
            }
          }
          else {
            self.peripheralMap[identifier] = scannedPeripheralItem
            self.peripherals = self.peripheralMap.values.map { $0 }.sorted { $0.rssi > $1.rssi }
          }
        }
      )
  }

  func stopScan() {
    centralManager.stopScan()
    canUpdate = false
  }

  func itemViewWasTapped(with item: ScannedPeripheralItem) {
    stopScan()
    guard let selectedScanResult = blePeripheralMap[item.identifier] else { return }
    if let oldScanResult = scanResult,
      oldScanResult.peripheral.associatedPeripheral.identifier
        == selectedScanResult.peripheral.associatedPeripheral.identifier
    {
      return
    }

    let selectedServiceViewModel = ServicesViewModel(
      scanResult: selectedScanResult,
      parentViewModel: self
    )
    self.selectedServiceViewModel = selectedServiceViewModel
    selectedCharacteristicViewModel = nil
    scanResult = selectedScanResult

    detailScreens = [.services(selectedServiceViewModel)]
  }

}

struct ScannedPeripheralItem {
  let rssi: Double
  let name: String
  let identifier: UUID
}
