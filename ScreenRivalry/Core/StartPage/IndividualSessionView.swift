//
//  IndividualSessionView.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/1/24.
//

import SwiftUI
import Combine

class AppStateViewModel: ObservableObject {
    @Published var isInForeground: Bool = true
}


struct IndividualSessionView: View {
    @Environment(\.scenePhase) var scenePhase
    @StateObject private var appStateViewModel = AppStateViewModel()
    var body: some View {
        VStack {
            if appStateViewModel.isInForeground {
                Text("The app is in the foreground.")
            } else {
                Text("The app is in the background.")
            }
        }
        .onChange(of: scenePhase) {
            switch scenePhase {
            case .active:
                appStateViewModel.isInForeground = true
                print("App is in the foreground.")
            case .inactive:
                appStateViewModel.isInForeground = false
                print("App is inactive.")
            case .background:
                appStateViewModel.isInForeground = false
                print("App is in the background.")
            @unknown default:
                break
            }
        }
    }
}

#Preview {
    IndividualSessionView()
}
