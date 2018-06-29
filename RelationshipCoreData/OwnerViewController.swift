//
//  OwnerViewController.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 27/06/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//

import UIKit
import CoreData

protocol OwnerSelectionDelegate: class {
    func selectedOwner(selectedUser: User, Controller: UIViewController)
}

class OwnerViewController: UIViewController {

    @IBOutlet weak var ownerTableView: UITableView!
    var userTableData = [User]()
    var pickOwner:Bool? = false
    var selectedOwner:User?
    weak var delegate:OwnerSelectionDelegate?
    
    struct storyboardID {
        static let SHOWDEVICES = "showDevices"
    }
    
    //MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ownerTableView.delegate = self
        self.ownerTableView.dataSource = self
        // Do any additional setup after loading the view.
    }

    //MARK: view will appear
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.LoadOwnerData()
        self.ownerTableView.reloadData()
    }
    
    //MARK: view will disappear
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == storyboardID.SHOWDEVICES {
            let OwnerScreen = segue.destination as! OwnerDevicesViewController
            OwnerScreen.selectedOwner = self.selectedOwner
        }
    }
    
    //MARK: Fetch data from CORE DATA model User whcih contain owner details
    func LoadOwnerData() -> Void {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let fetchUserRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "User")
        do {
            if let resultUser =  try appDelegate.persistentContainer.viewContext.fetch(fetchUserRequest) as? [User] {
                self.userTableData = resultUser
            }
        } catch {
            print("Cannot fetch user")
        }
    }
    
    //MARK: add button action
    @IBAction func AddButtonAction(_ sender: Any) {
        self.ShowCustomAlertView()
    }
    
    //MARK: showing custom alert view
    func ShowCustomAlertView(){
        let alert = UIAlertController(title: "Add New Owner", message: "Please enter name", preferredStyle: UIAlertControllerStyle.alert)
        
        alert.addTextField(configurationHandler: configurationTextField)
        
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("User click Ok button")
            let name = alert.textFields?[0].text ?? ""
            self.addOwnerToDB(Name:name)
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler:{ (UIAlertAction)in
            print("Dialog box closed")
        }))
        
        self.present(alert, animated: true, completion:nil)
    }
    
    //MARK: add user button aciton and add to DB
    func addOwnerToDB(Name:String) -> Void {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        guard let userEntity = NSEntityDescription.entity(forEntityName: "User", in: appDelegate.persistentContainer.viewContext) else {
            fatalError("Could not find entity User")
        }
            let device_user = User.init(entity: userEntity, insertInto: appDelegate.persistentContainer.viewContext)
            device_user.name = Name
        
        do {
            try appDelegate.persistentContainer.viewContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.LoadOwnerData()
        self.ownerTableView.reloadData()
     }
    
    //MARK: Add textfield in alert view 
    func configurationTextField(textField: UITextField!){
        textField.placeholder = "Owner Name"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension OwnerViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.userTableData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "usercell") as UITableViewCell!
        
        let name = self.userTableData[indexPath.row].name
        cell.textLabel?.text = name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if self.pickOwner! {
            self.delegate?.selectedOwner(selectedUser: self.userTableData[indexPath.row], Controller: self)
        } else {
            self.selectedOwner = self.userTableData[indexPath.row]
            performSegue(withIdentifier: storyboardID.SHOWDEVICES, sender: User?.self)
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if self.pickOwner == false {
            return true
        }else{
            return false
        }
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        if editingStyle == .delete {
            let person = self.userTableData[indexPath.row]
            appDelegate.persistentContainer.viewContext.delete(person)
        }
        self.LoadOwnerData()
        tableView.reloadData()
    }
    
}
