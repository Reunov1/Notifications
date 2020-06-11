//
//  AppDelegate.swift
//  Notifications
//
//  Created by Александр Реунов on 11.06.2020.
//  Copyright © 2020 Александр Реунов. All rights reserved.
//

import UIKit
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

// центр уведомлений/управление уведомлениями
    
    let notificationCentre = UNUserNotificationCenter.current()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        requestAutorisation()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // запрос авторизации
    
    func requestAutorisation() {
        notificationCentre.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            print("Permission grated: \(granted)")
            
            guard granted else { return }
            self.getNotificationSettings()
        }
    }
    
    // отслеживание настроек по уведомлениям у пользователя
    
    func getNotificationSettings() {
        notificationCentre.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }

}

