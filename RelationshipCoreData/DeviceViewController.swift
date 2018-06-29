//
//  DeviceViewController.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 27/06/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//

import UIKit
import CoreData

class DeviceViewController: UIViewController {

    @IBOutlet weak var deviceTableView: UITableView!
    var DeviceTableArray = [Device]()
    var selectedDevice:Device! = nil
    
    //StoryBoard data Sugue ID
    struct StoryBoardID {
        static let EDITSCREEN = "editData"
    }
    
    //MARK: view did load
    override func viewDidLoad() {
        super.viewDidLoad()
        self.deviceTableView.delegate = self
        self.deviceTableView.dataSource = self
    }
    
    //MARK: Fetch Data From COREDATA model Devices
    func LoadData(deviceTypeFilter: String? = nil) -> Void {
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Device")
        if let deviceTypeFilter = deviceTypeFilter {
            let filterPredicate = NSPredicate(format: "deviceType =[c] %@",deviceTypeFilter)
            fetchRequest.predicate = filterPredicate
        }
        do {
            if let resultsDevice = try appDelegate.persistentContainer.viewContext.fetch(fetchRequest) as? [Device]  {
                self.DeviceTableArray = resultsDevice
            }
        } catch {
            print("Cannot fetch device")
        }
        
        self.deviceTableView.reloadData()
    }
    
    //MARK: view will appear 
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        selectedDevice = nil
        self.LoadData()
    }
    //MARK: prepare segue method and pass the data to next view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == StoryBoardID.EDITSCREEN {
            let EditScreen = segue.destination as! EditDataViewController
            EditScreen.selectedDevice = self.selectedDevice
        }
        
    }
    //MARK: View will disappaer
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)

    }
    
    @IBAction func addFilter(_ sender: Any) {
        let sheet = UIAlertController(title: "Filter Options", message: nil, preferredStyle: .actionSheet)
        
        sheet.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: { (action) -> Void in
        }))
        
        sheet.addAction(UIAlertAction.init(title: "Show All", style: .default, handler: { (action) -> Void in
            self.LoadData()
        }))
       
        sheet.addAction(UIAlertAction.init(title: "Show iPhones", style: .default, handler: { (action) -> Void in
            self.LoadData(deviceTypeFilter: "iPhone")
        }))

        sheet.addAction(UIAlertAction.init(title: "Show Watches", style: .default, handler: { (action) -> Void in
            self.LoadData(deviceTypeFilter: "watch")
        }))

        present(sheet, animated: true, completion: nil)
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: TableView Delegates 
extension DeviceViewController: UITableViewDelegate,UITableViewDataSource {
    
    //Tableview delegates
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return self.DeviceTableArray.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedDevice = self.DeviceTableArray[indexPath.row]
        performSegue(withIdentifier: StoryBoardID.EDITSCREEN, sender: Device?.self)
    }
    
    //Tableview datasource
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
        var cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as UITableViewCell!
        if cell == nil {
            cell = UITableViewCell(style: UITableViewCellStyle.value1, reuseIdentifier: "Cell")
        }
        let deviceType = self.DeviceTableArray[indexPath.row].deviceType
        let name = self.DeviceTableArray[indexPath.row].name
        let owner = self.DeviceTableArray[indexPath.row].owner?.name ?? ""
        cell?.textLabel?.text = "\(name) \(deviceType)"
        cell?.detailTextLabel?.text = "Owner: \(owner)"
        return cell!
    }

    
}
