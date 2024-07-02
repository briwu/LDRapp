//
//  ContentView.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/1/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
        Group {
            if viewModel.userSession != nil {
                MainTabView()
                    .environmentObject(viewModel)
            } else {
                LoginView()
            }
        }
    }
}

#Preview {
    ContentView()
}
