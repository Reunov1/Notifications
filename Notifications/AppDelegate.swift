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

    var window: UIWindow?
    let notifications = Notifications()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        notifications.requestAutorization()
        notifications.notificationCenter.delegate = notifications
        return true
    }

    // убираем бейджик после прочтения уведомле

    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0
    }
    
    

}
