//
//  MainTabView.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/1/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    var body: some View {
            
        TabView {
            StartPageView()
                .tabItem { Image(systemName: "house.fill") }
                .tag(0)
                
            Text("Search View")
                .tabItem { Image(systemName: "magnifyingglass") }
                .tag(1)
                
            Text("Inbox View")
                .tabItem { Image(systemName: "bubble") }
                .tag(2)
                
            ProfileView()
                .tabItem { Image(systemName: "person") }
                .tag(3)
        }
        .tint(.primary)
        
    }
}


#Preview {
    MainTabView()
}

