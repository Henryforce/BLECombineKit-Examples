//
//  DevicesView.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import Combine
import SwiftUI

struct DevicesView: View {

  @ObservedObject var viewModel: DevicesViewModel
  //    @ObservedObject var servicesViewModel = ServicesViewModel()
  @State private var actionState: ActionState? = .setup

  var body: some View {
    VStack {
      //            NavigationLink(destination: ServicesView(viewModel: servicesViewModel), tag: .readyForPush, selection: $actionState) {
      //                EmptyView()
      //            }
      List {
        ForEach(viewModel.peripherals, id: \.identifier) { item in
          ItemView(peripheral: item)
            .onTapGesture {
              self.itemViewWasTapped(with: item)
            }
        }
      }
    }
    //        .onAppear() {
    //            self.servicesViewModel.reset()
    //        }
  }

  private func itemViewWasTapped(with item: ScannedPeripheralItem) {
    viewModel.itemViewWasTapped(with: item)
  }
}

struct ItemView: View {
  let peripheral: ScannedPeripheralItem

  var body: some View {
    VStack {
      HStack {
        Text(peripheral.name)
          .font(.title)
        Spacer()
      }
      HStack {
        Text(peripheral.identifier.uuidString)
          .font(.footnote)
        Spacer()
        Text(String(peripheral.rssi))
          .font(.subheadline)
      }
    }.padding()
  }
}
