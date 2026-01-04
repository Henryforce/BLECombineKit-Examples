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

  @StateObject var viewModel: DevicesViewModel

  init(with viewModel: DevicesViewModel) {
    self._viewModel = StateObject(wrappedValue: viewModel)
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
              .id(screen)
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
