//
//  BLEExplorerScreenView.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import Foundation
import SwiftUI

enum BLEExplorerScreen {
  case services(ServicesViewModel)
  case characteristics(CharacteristicsViewModel)
  case characteristicDetails(CharacteristicDetailViewModel)
}

struct BLEExplorerScreenView: View {
  let screen: BLEExplorerScreen

  var body: some View {
    switch screen {
    case .services(let viewModel):
      ServicesView(viewModel: viewModel)
    case .characteristics(let viewModel):
      CharacteristicsView(viewModel: viewModel)
    case .characteristicDetails(let viewModel):
      CharacteristicDetailView(viewModel: viewModel)
    }
  }
}

extension BLEExplorerScreen: Equatable {
  static func == (lhs: BLEExplorerScreen, rhs: BLEExplorerScreen) -> Bool {
    switch (lhs, rhs) {
    case (.services(let leftViewModel), .services(let rightViewModel)):
      return leftViewModel === rightViewModel
    case (.characteristics(let leftViewModel), .characteristics(let rightViewModel)):
      return leftViewModel === rightViewModel
    case (.characteristicDetails(let leftViewModel), .characteristicDetails(let rightViewModel)):
      return leftViewModel === rightViewModel
    default: return false
    }
  }
}

extension BLEExplorerScreen: Hashable {
  func hash(into hasher: inout Hasher) {
    switch self {
    case .services(let viewModel):
      hasher.combine(viewModel.id)
    case .characteristics(let viewModel):
      hasher.combine(viewModel.id)
    case .characteristicDetails(let viewModel):
      hasher.combine(viewModel.id)
    }
  }
}
