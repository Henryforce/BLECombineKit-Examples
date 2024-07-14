//
//  CharacteristicsView.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import Combine
import SwiftUI

struct CharacteristicsView: View {

  @ObservedObject var viewModel: CharacteristicsViewModel
  @State private var actionState: ActionState? = .setup

  var body: some View {
    VStack {
      List {
        ForEach(viewModel.characteristics, id: \.value) { characteristic in
          Text(characteristic.value.uuid.uuidString)
            .font(.subheadline)
            .onTapGesture {
              viewModel.selectCharacteristic(characteristic)
            }
        }
      }.padding()
        .onAppear {
          viewModel.startObservingCharacteristics()
        }
    }
  }
}
