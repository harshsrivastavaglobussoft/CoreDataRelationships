//
//  OwnerDevicesViewController.swift
//  RelationshipCoreData
//
//  Created by Sumit Ghosh on 29/06/18.
//  Copyright © 2018 Sumit Ghosh. All rights reserved.
//

import UIKit

class OwnerDevicesViewController: UIViewController {

    var selectedOwner:User?
    var Devices = [Device]()
    @IBOutlet weak var ownerDevicesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Devices = self.selectedOwner?.devices.allObjects as! [Device]
        self.ownerDevicesTableView.delegate = self
        self.ownerDevicesTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension OwnerDevicesViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "deviceCell") as UITableViewCell!
        
        let deviceType = self.Devices[indexPath.row].deviceType
        let name = self.Devices[indexPath.row].name
        cell.textLabel?.text = "\(name) \(deviceType)"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.Devices.count
    }
}
