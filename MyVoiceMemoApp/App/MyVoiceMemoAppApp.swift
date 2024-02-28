//
//  MyVoiceMemoAppApp.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/14/24.
//

import SwiftUI

@main
struct MyVoiceMemoAppApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            OnboardingView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
