//
//  CharacteristicsDetailView.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import SwiftUI

struct CharacteristicDetailView: View {

  @ObservedObject var viewModel: CharacteristicDetailViewModel

  var body: some View {
    VStack {
      Button(action: {
        self.viewModel.readValue()
      }) {
        Text("Read Value")
      }
      DataStringView(title: "Encoded Data: ", dataString: viewModel.encodedData)
      DataStringView(title: "Hex Data: ", dataString: viewModel.hexData)
    }
  }

}

struct DataStringView: View {

  var title: String
  var dataString: String

  var body: some View {
    HStack {
      Text(title)
        .font(.subheadline)
      Text(dataString)
        .font(.subheadline)
    }.frame(alignment: .center)
  }

}
