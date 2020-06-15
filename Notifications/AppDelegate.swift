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
    let notificationCenter = UNUserNotificationCenter.current()

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        requestAutorization()
        notificationCenter.delegate = self
        return true
    }

    
    // убираем бейджик после прочтения уведомления
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UIApplication.shared.applicationIconBadgeNumber = 0

    }
    

    // запрос авторизации
    
    func requestAutorization() {
           notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
               print("Permission granted: \(granted)")
               
               guard granted else { return }
               self.getNotificationSettings()
           }
       }
    
    // отслеживание настроек по уведомлениям у пользователя
    
   func getNotificationSettings() {
        notificationCenter.getNotificationSettings { (settings) in
            print("Notification settings: \(settings)")
        }
    }
    
    // создание запроса на уведомелние (рассписание уведомлений)
    
    func scheduleNotification(notificationTape:String) {
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = notificationTape
        content.body = "This is example how to create" + notificationTape
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // дабавляем запрос в центр уведомления
        
        let identifire = "Local Notification"
        let request = UNNotificationRequest(identifier: identifire, content: content, trigger: trigger)
        
        // вызываем запрос в центре уведомлений
        
       notificationCenter.add(request) { (error) in
        if let error = error {
            print("Error \(error.localizedDescription)")
         }
        
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Smooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(identifier: userAction, actions: [snoozeAction,deleteAction], intentIdentifiers: [], options: [])
        
        notificationCenter.setNotificationCategories([category])

      }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        willPresent notification: UNNotification,
        withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        completionHandler([.alert, .sound])
    }
    
    func userNotificationCenter(
        _ center: UNUserNotificationCenter,
        didReceive response: UNNotificationResponse,
        withCompletionHandler completionHandler: @escaping () -> Void) {
        
        if response.notification.request.identifier == "Local Notification" {
            print("Handling notification with the Local Notification Identifire")
        }
        
        switch response.actionIdentifier {
        case UNNotificationDismissActionIdentifier:
            print("Dismiss Action")
        case UNNotificationDismissActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notificationTape: "Reminder")
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }
}

