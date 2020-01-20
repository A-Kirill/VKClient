//
//  AppDelegate.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 10.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        
        //creating secret key... Its necessary to save it secure!!! (examp: Keychain)
       /* var key = Data(count: 64)
        _ = key.withUnsafeMutableBytes { bytes in
            SecRandomCopyBytes(kSecRandomDefault, 64, bytes)
        }*/
        
        //Migration block for Realm
        let config = Realm.Configuration(/*encryptionKey: key,*/ schemaVersion: 3 )
        Realm.Configuration.defaultConfiguration = config
        
        //Show start screen if we have token
        let realm = try! Realm()
        if let settings = realm.objects(UserSettings.self).first,
          settings.token != "",
            settings.id != 0 {

            Session.instance.token = settings.token
            Session.instance.userId = String(describing: settings.id)

            window = UIWindow(frame: CGRect(x: 0,
                                            y: 0,
                                            width: UIScreen.main.bounds.width,
                                            height: UIScreen.main.bounds.height))

            let storyBoard = UIStoryboard(name: "Main", bundle: nil)
            let contentScreen = storyBoard.instantiateViewController(withIdentifier: "MainScreen")
            window?.rootViewController = contentScreen
        }
        
        // UserDefaults
        let isAuthorized = UserDefaults.standard.bool(forKey: "isAuthorized")
        print(isAuthorized)
        UserDefaults.standard.set(true, forKey: "isAuthorized")
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

