//
//  AppDelegate.swift
//  MyVoiceMemoApp
//
//  Created by 최안용 on 2/24/24.
//

import UIKit

final class AppDelegate: NSObject, UIApplicationDelegate {
    var notificationDelegate = NotificationDelete()
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil
    ) -> Bool {
        UNUserNotificationCenter.current().delegate = notificationDelegate
        return true
    }
}
