//
//  ScreenRivalryApp.swift
//  ScreenRivalry
//
//  Created by Brian Wu on 7/1/24.
//

import SwiftUI
import Firebase
import FirebaseCore
/*
class AppDelegate: NSObject, UIApplicationDelegate {

  func application(_ application: UIApplication,

                   didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {

    FirebaseApp.configure()

    return true

  }
}
 */

@main
struct ScreenRivalryApp: App {
    //@UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject var viewModel = AuthViewModel()
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(viewModel)
        }
    }
}
