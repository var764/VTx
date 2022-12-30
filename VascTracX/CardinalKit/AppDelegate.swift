//
//  AppDelegate.swift
//
//  Created for the CardinalKit Framework.
//  Copyright © 2019 Stanford University. All rights reserved.
//
import UIKit
import Firebase
import ResearchKit

// import facebook
import FBSDKCoreKit
import UserNotifications
import GoogleSignIn
import CardinalKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
                
        // (1) initialize Firebase SDK
        FirebaseApp.configure()
        
        // (2) check if this is the first time
        // that the app runs!
        cleanIfFirstRun()
        
        // (3) initialize CardinalKit API
        CKAppLaunch()
        
        let config = CKPropertyReader(file: "CKConfiguration")
        UIView.appearance(whenContainedInInstancesOf: [ORKTaskViewController.self]).tintColor = config.readColor(query: "Tint Color")
        
        // Fix transparent navbar in iOS 15
               if #available(iOS 15, *) {
                   let appearance = UINavigationBarAppearance()
                   appearance.configureWithOpaqueBackground()
                   UINavigationBar.appearance().standardAppearance = appearance
                   UINavigationBar.appearance().scrollEdgeAppearance = appearance
               }
        
        // Set up FB Sign In
        FBSDKCoreKit.ApplicationDelegate.shared.application(
                    application,
                    didFinishLaunchingWithOptions: launchOptions
                )
        
        registerForPushNotifications()
        localNotification()
        
        
        return true
    }
    

    
    
    // Set up Google Sign In
    @available(iOS 9.0, *)
    func application(_ application: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any])
      -> Bool {
          
          ApplicationDelegate.shared.application(
              application,
              open: url,
              sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
              annotation: options[UIApplication.OpenURLOptionsKey.annotation]
          )
          
      return GIDSignIn.sharedInstance.handle(url)
    }
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func getNotificationSettings() {
      UNUserNotificationCenter.current().getNotificationSettings { settings in
          print("Notification settings: \(settings)")
          guard settings.authorizationStatus == .authorized else { return }

          
      }
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(
            options: [.alert, .sound, .badge]) { [weak self] granted, _ in
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
            }
    }
    
    
    func localNotification() {
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }
        
        let content = UNMutableNotificationContent()
        content.title = NSString.localizedUserNotificationString(forKey: "VascTrac X Tasks", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: "There are tasks for you to complete in the app.",
                                                                arguments: nil)
          
        let defaults = UserDefaults.standard
        // Configure the trigger for a 7am wakeup.
        var components = DateComponents()
        components.calendar = Calendar.current
        var postOperativeDate = defaults.object(forKey: "postOperativeDate") as? Date ?? Date()
        print("Notif Post Op")
        print(postOperativeDate)
        let notif30Date = Calendar.current.date(byAdding: .day, value: 30, to: postOperativeDate )
        let notif30Components = Calendar.current.dateComponents([.year, .month, .day], from: notif30Date!)
        var trigger30 = UNCalendarNotificationTrigger(dateMatching: notif30Components, repeats: false)
        
        let notif60Date = Calendar.current.date(byAdding: .day, value: 60, to: postOperativeDate )
        let notif60Components = Calendar.current.dateComponents([.year, .month, .day], from: notif60Date!)
        var trigger60 = UNCalendarNotificationTrigger(dateMatching: notif60Components, repeats: false)
        
        
        // Create the request object.
        let request30 = UNNotificationRequest(identifier: "30 Day Reminder", content: content, trigger: trigger30)
        
        let request60 = UNNotificationRequest(identifier: "60 Day Reminder", content: content, trigger: trigger60)
        
        let uuidString = UUID().uuidString

        // Schedule the request with the system.
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.add(request30) { (error) in
           if error != nil {
              // Handle any errors.
           }
        }
        notificationCenter.add(request60) { (error) in
            if error != nil {
                
            }
        }
        }
    }
    
    
  /*  func deliverNotifications() {
        
        let center = UNUserNotificationCenter.current()
        center.getNotificationSettings { settings in
            guard (settings.authorizationStatus == .authorized) ||
                  (settings.authorizationStatus == .provisional) else { return }
            
            let content = UNMutableNotificationContent()
            content.title = "VascTrac X - Walking Test"
            content.body = "If able, please complete your 6-minute walking test today."
        
            // Configure the recurring date.
            var dateComponents = DateComponents()
            dateComponents.calendar = Calendar.current
           
            // Create the trigger as a repeating event.
            let trigger_one = UNTimeIntervalNotificationTrigger(timeInterval: (2592000), repeats: false)
            let trigger_two = UNTimeIntervalNotificationTrigger(timeInterval: (5184000), repeats: false)
        
            let uuidString = UUID().uuidString
            let request_one = UNNotificationRequest(identifier: uuidString,
                    content: content, trigger: trigger_one)
            let request_two = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger_two)

            // Schedule the request with the system.
            let notificationCenter = UNUserNotificationCenter.current()
            notificationCenter.add(request_one) { (error) in
                if error != nil {
                    // Handle any errors.
                }
            }
            notificationCenter.add(request_two) { (error) in
                if error != nil {
                    // Handle any errors.
                }
            }
        }
    } */
    
    
}

// Extensions add new functionality to an existing class, structure, enumeration, or protocol type.
// https://docs.swift.org/swift-book/LanguageGuide/Extensions.html
extension AppDelegate {
    
    /**
     The first time that our app runs we have to make sure that :
     (1) no passcode remains stored in the keychain &
     (2) we are fully signed out from Firebase.
     
     This step is required as an edge-case, since
     keychain items persist after uninstallation.
    */
    fileprivate func cleanIfFirstRun() {
        if !UserDefaults.standard.bool(forKey: Constants.prefFirstRunWasMarked) {
            if ORKPasscodeViewController.isPasscodeStoredInKeychain() {
                ORKPasscodeViewController.removePasscodeFromKeychain()
            }
            try? Auth.auth().signOut()
            UserDefaults.standard.set(true, forKey: Constants.prefFirstRunWasMarked)
        }
    }
    
}

