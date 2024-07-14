//
//  BLECombineKitExplorerApp.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import CoreBluetooth
import SwiftUI

@main
struct BLECombineKitExplorerApp: App {
  let centralManager = BLECombineKit.buildCentralManager(with: CBCentralManager())

  var body: some Scene {
    return WindowGroup {
      ContentView(with: DevicesViewModel(centralManager: centralManager))
    }
  }
}
