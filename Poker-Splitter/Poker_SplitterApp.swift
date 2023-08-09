//
//  Poker_SplitterApp.swift
//  Poker-Splitter
//
//  Created by Max Pintchouk on 8/2/23.
//

import SwiftUI
import Firebase

@main
struct Poker_SplitterApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            HomeView().environmentObject(SessionStore())

        }
    }
}

class AppDelegate: UIResponder, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        FirebaseApp.configure()
        return true
    }
}
