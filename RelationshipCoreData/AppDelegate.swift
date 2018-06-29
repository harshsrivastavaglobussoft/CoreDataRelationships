//
//  AppDelegate.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 27/06/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.fetchAllData()
        return true
    }
    
    //MARK: Fetch all data and accordingly fill demo data
    @objc func fetchAllData() -> Void {
        self.getDeviceData()
        self.getUserData()
    }
    
    //MARK: get data for device attribute
    func getDeviceData() -> Void {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        do {
            if let resultsDevice = try persistentContainer.viewContext.fetch(fetchRequest) as? [Device]  {
                if resultsDevice.count == 0 {
                    self.addTestData()
                }
            }
        } catch {
            print("Cannot fetch device")
        }
        
    }
    
    //MARK: get data for user attribute
    func getUserData() -> Void {
        let fetchUserRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            if let resultUser =  try persistentContainer.viewContext.fetch(fetchUserRequest) as? [User] {
                if resultUser.count == 0 {
                    self.addDataToUsers()
                }
            }
        } catch {
            print("Cannot fetch user")
        }
        
    }
    //MARK: add test data to device attribte
    func addTestData() -> Void {
        //Create the entity
        guard let entity = NSEntityDescription.entity(forEntityName: "Device", in: persistentContainer.viewContext) else {
            fatalError("Could not find entiyu description")
        }
        //Create the NSManagedObject
        
        for i in 1...10 {
            let device = Device.init(entity: entity, insertInto: persistentContainer.viewContext)
            device.name = "Some Device #\(i)"
            device.deviceType = i % 3 == 0 ? "Watch" : "iPhone"
            device.osVersion = i % 3 == 0 ? "watchOS 4.6" : "iOS 11.3"
        }
    }
    
    //MARK: add data to User attribute
    func addDataToUsers() -> Void {
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: persistentContainer.viewContext) else {
            fatalError("Could not find entity User")
        }
        let arrayName = ["Rogers","Stark","Banner","Barten"]
        for i in 0 ..< arrayName.count {
            let device_user = User.init(entity: userEntity, insertInto: persistentContainer.viewContext)
            device_user.name = arrayName[i]
        }
  
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
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "RelationshipCoreData")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

