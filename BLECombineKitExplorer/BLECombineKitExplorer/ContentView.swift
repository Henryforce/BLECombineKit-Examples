//
//  ContentView.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import Combine
import CoreBluetooth
import SwiftUI

struct ContentView: View {

  @ObservedObject var viewModel: DevicesViewModel

  init(with viewModel: DevicesViewModel) {
    self.viewModel = viewModel
  }

  var body: some View {

    NavigationSplitView {
      DevicesView(viewModel: viewModel)
        .navigationTitle("Devices")
    } detail: {
      NavigationStack(path: $viewModel.detailScreens) {
        EmptyView()
          .navigationDestination(for: BLEExplorerScreen.self) { screen in
            BLEExplorerScreenView(screen: screen)
          }
      }
    }
    .onAppear {
      Task {
        try await Task.sleep(for: .seconds(2))
        viewModel.startScanning()
        try await Task.sleep(for: .seconds(2))
        viewModel.stopScan()
      }
    }
  }
}

//#Preview {
//    ContentView()
//}
