//
//  EditDataViewController.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 27/06/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//

import UIKit
import CoreData

class EditDataViewController: UIViewController {

    @IBOutlet weak var deviceCodeTextField: UITextField!
    @IBOutlet weak var deviceTypeTextField: UITextField!
    @IBOutlet weak var ownerLabel: UILabel!
    @IBOutlet weak var purchaseDateTextField: UITextField!
    @IBOutlet weak var osversionTextField: UITextField!
    
    var selectedDevice: Device?
    var deviceCode:String?
    var deviceType:String?
    var user:User?
    
    struct StoryBoardIDS {
       static let OWNERLIST = "ownerLink"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if selectedDevice != nil {
            deviceType = selectedDevice?.deviceType
            deviceCode = selectedDevice?.name
            self.deviceCodeTextField.text = deviceCode
            self.deviceTypeTextField.text = deviceType
            if selectedDevice?.owner == nil {
                self.ownerLabel.text = "Tap to Select"
            }else{
                self.ownerLabel.text = selectedDevice?.owner?.name ?? ""
            }
            self.osversionTextField.text = selectedDevice?.osVersion
            
            if selectedDevice?.purchaseDate == nil {
                self.purchaseDateTextField.placeholder = "Please enter Date"
            }else{
                self.purchaseDateTextField.text = selectedDevice?.purchaseDate
            }
        }

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoardIDS.OWNERLIST {
            let OwnerScreen = segue.destination as! OwnerViewController
            OwnerScreen.pickOwner = true
            OwnerScreen.delegate = self
        }
    }
    

    @IBAction func saveButtonAction(_ sender: Any) {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        if selectedDevice == nil {
            self.insertOperation()
        }else{
            self.updateFunction()
        }
        
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        self.shwoingSccessAlertMessage()
    }
    
    func shwoingSccessAlertMessage() -> Void {
        let alert = UIAlertController(title: "Success", message: "Adding/Updating data in  Local DB ", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
            switch action.style{
            case .default:
                print("default")
            case .cancel:
                print("cancel")
            case .destructive:
                print("destructive")
            }}))
        self.present(alert, animated: true, completion: nil)
    }
    
    //MARK: Update Operation in coredata using NSManagedObjectContext
    func updateFunction() -> Void {
        self.selectedDevice?.name = self.deviceCodeTextField.text ?? ""
        self.selectedDevice?.deviceType = self.deviceTypeTextField.text ?? ""
        self.selectedDevice?.owner = self.user
        self.selectedDevice?.osVersion = self.osversionTextField.text ?? ""
        self.selectedDevice?.purchaseDate = self.purchaseDateTextField.text ?? ""
    }
    
    //MARK: Insert Operation in coredata using NSManagedObjectContext
    func insertOperation() -> Void {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        guard let entity = NSEntityDescription.entity(forEntityName: "Device", in: appDelegate.persistentContainer.viewContext) else {
            fatalError("Could not find entiyu description")
        }
            let device = Device.init(entity: entity, insertInto: appDelegate.persistentContainer.viewContext)
            let deviceName = deviceCodeTextField.text ?? ""
            device.name = "Some Device #\(deviceName)"
            device.deviceType = deviceTypeTextField.text ?? ""
            device.owner = self.user
            device.purchaseDate = self.purchaseDateTextField.text ?? ""
            device.osVersion = self.osversionTextField.text ?? ""
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension EditDataViewController:OwnerSelectionDelegate {
    func selectedOwner(selectedUser: User, Controller: UIViewController) {
        self.user = selectedUser
        self.ownerLabel.text = selectedUser.name
        Controller.navigationController?.popViewController(animated: true)
    }
}
