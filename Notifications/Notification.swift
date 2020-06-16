//
//  Notification.swift
//  Notifications
//
//  Created by Александр Реунов on 15.06.2020.
//  Copyright © 2020 Александр Реунов. All rights reserved.
//


import UIKit
import UserNotifications

class Notifications: NSObject, UNUserNotificationCenterDelegate {
    
    let notificationCenter = UNUserNotificationCenter.current()
    
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
    
    func scheduleNotification(notifaicationType: String) {
        
        let content = UNMutableNotificationContent()
        let userAction = "User Action"
        
        content.title = notifaicationType
        content.body = "This is example how to create " + notifaicationType
        content.sound = UNNotificationSound.default
        content.badge = 1
        content.categoryIdentifier = userAction
        
        // цепляем картинку на уведомления
        
        guard let path = Bundle.main.path(forResource: "favicon", ofType: "png") else { return }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let attachment = try UNNotificationAttachment(identifier: "favicon", url: url, options: nil)
            
            content.attachments = [attachment]
        } catch {
            print("The attachment cold not be loaded")
        }
        
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        
        // дабавляем запрос в центр уведомления
        
        let identifire = "Local Notification"
        let request = UNNotificationRequest(identifier: identifire,
                                            content: content,
                                            trigger: trigger)
        
         // вызываем запрос в центре уведомлений
        
        notificationCenter.add(request) { (error) in
            if let error = error {
                print("Error \(error.localizedDescription)")
            }
        }
        
        let snoozeAction = UNNotificationAction(identifier: "Snooze", title: "Snooze", options: [])
        let deleteAction = UNNotificationAction(identifier: "Delete", title: "Delete", options: [.destructive])
        let category = UNNotificationCategory(
            identifier: userAction,
            actions: [snoozeAction, deleteAction],
            intentIdentifiers: [],
            options: [])
        
        notificationCenter.setNotificationCategories([category])
    }
    
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
        case UNNotificationDefaultActionIdentifier:
            print("Default")
        case "Snooze":
            print("Snooze")
            scheduleNotification(notifaicationType: "Reminder")
        case "Delete":
            print("Delete")
        default:
            print("Unknown action")
        }
        
        completionHandler()
    }

}
