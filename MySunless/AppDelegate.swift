//
//  AppDelegate.swift
//  MySunless
//
//  Created by iMac on 05/10/21.
//

import UIKit
import IQKeyboardManager
import SwiftyStoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        //Mark:- Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        IQKeyboardManager.shared().isEnabled = true
        
        UserDefaults.standard.removeObject(forKey: "arrCollectionUsers")
        UserDefaults.standard.removeObject(forKey: "arrCollectionIds")
        
        //For running in siumulator
      //  UserDefaults.standard.set(true, forKey: "currentSubscription")

        SwiftyStoreKit.completeTransactions(atomically: true) { purchases in
            for purchase in purchases {
                switch purchase.transaction.transactionState {
                case .purchased, .restored:
                    if purchase.needsFinishTransaction {
                       // SwiftyStoreKit.finishTransaction(purchase.transaction)
                    }
                    print("purchased or restored")
                    UserDefaults.standard.set(true, forKey: "currentSubscription")
                case .failed, .purchasing, .deferred:
                    print("failed or purchasing or deferred")
                    UserDefaults.standard.set(false, forKey: "currentSubscription")
                    break
                @unknown default:
                    print("error")
                }
            }     
        }
     //   getInAppPrice()
        
        return true
    }
    
//    func getInAppPrice() {
//        SwiftyStoreKit.retrieveProductsInfo(Set<String>(ProductType.all.map({$0.rawValue}))) { (result) in
//            let products = result.retrievedProducts
//            var arrProduct = [[String:String]]()
//            for p in products {
//                let dict = [p.productIdentifier : p.localizedPrice]
//                arrProduct.append(dict as! [String : String])
//            }
////            UserDefaults.standard.set(arrProduct, forKey: "kAllPlans")
////            UserDefaults.standard.synchronize()
//        }
//    }
    
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


}

