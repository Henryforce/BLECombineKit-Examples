//
//  ServicesView.swift
//  BLECombineKitExplorer
//
//  Created by Henry Javier Serrano Echeverria on 14/7/24.
//

import BLECombineKit
import Combine
import SwiftUI

struct ServicesView: View {

  @ObservedObject var viewModel: ServicesViewModel
  //    @ObservedObject var characteristicsViewModel = CharacteristicsViewModel()
  @State private var actionState: ActionState? = .setup

  var body: some View {
    VStack {
      //            NavigationLink(destination: CharacteristicsView(viewModel: characteristicsViewModel),
      //                           tag: .readyForPush,
      //                           selection: $actionState) {
      //                EmptyView()
      //            }
      List {
        ForEach(viewModel.services, id: \.value) { service in
          HStack {
            Text(service.value.uuid.uuidString)
              .font(.subheadline)
          }.onTapGesture {
            //                        self.characteristicsViewModel.service = service
            //                        self.characteristicsViewModel.startObservingCharacteristics()
            //                        self.actionState = .readyForPush
            viewModel.serviceSelected(service)
          }
        }
      }.padding()
    }.onAppear {
      //            self.characteristicsViewModel.reset()
      viewModel.startObservingServices()
    }
    //        .navigationBarTitle(viewModel.name)
  }

}
