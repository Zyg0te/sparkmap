//
//  SettingsViewController.swift
//  Spark
//
//  Created by Edvard Holst on 02/02/16.
//  Copyright © 2016 Zygote Labs. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    
    @IBOutlet var switchOfflineMode: UISwitch!
    @IBOutlet var switchFastcharge: UISwitch!
    @IBOutlet var cellSchuko: UITableViewCell!
    @IBOutlet var cellChademo: UITableViewCell!
    @IBOutlet var cellType2: UITableViewCell!
    @IBOutlet var cellTesla: UITableViewCell!
    @IBOutlet var textFieldAmps: UITextField!
    
    let connectionIdSchuko = 28
    let connectionIdChademo = 2
    let connectionIdType2 = 25
    let connectionIdTeslaSupercharger = 27
    
    var connectionTypeIDs = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadUserSettingsToViews()
    }
    
    
    @IBAction func cancelButtonClicked(){
        dismissSettingsViewController()
    }
    
    @IBAction func doneButtonClicked(){
        //TOOD: Save settings
        saveUserSettings()
        dismissSettingsViewController()
    }
    
    func loadUserSettingsToViews(){
        let defaults = NSUserDefaults.standardUserDefaults()
        switchOfflineMode.setOn(defaults.boolForKey("offlineMode"), animated: true)
        switchFastcharge.setOn(defaults.boolForKey("fastchargeOnly"), animated: true)
        if let connectionTypeIDsFromSettings = NSUserDefaults.standardUserDefaults().arrayForKey("connectionFilterIds") {
            
            for id in connectionTypeIDsFromSettings {
                let idAsInt = id as! Int
                connectionTypeIDs.append(idAsInt)
                if (idAsInt == connectionIdSchuko){
                   cellSchuko.accessoryType = .Checkmark
                } else if (idAsInt == connectionIdType2) {
                    cellType2.accessoryType = .Checkmark
                } else if (idAsInt == connectionIdChademo) {
                    cellChademo.accessoryType = .Checkmark
                } else if (idAsInt == connectionIdTeslaSupercharger) {
                    cellTesla.accessoryType = .Checkmark
                }
            }
        }
        
        let ampsMinimumFromSettings = NSUserDefaults.standardUserDefaults().integerForKey("minAmps")
        if (ampsMinimumFromSettings > 0) {
            textFieldAmps.text = String(ampsMinimumFromSettings)
        }
    
        

    }
    
    func saveUserSettings(){
        
        // Store user preferences
        let defaults = NSUserDefaults.standardUserDefaults()
        // Offline Mode
        defaults.setBool(switchOfflineMode.on, forKey: "offlineMode")
        // Fastcharging Only
        defaults.setBool(switchFastcharge.on, forKey: "fastchargeOnly")
        // Connection Type IDs
        defaults.setObject(connectionTypeIDs, forKey: "connectionFilterIds")
        // Min Amps
        let minAmps = Int(textFieldAmps.text!)
        if minAmps != nil {
            defaults.setInteger(minAmps!, forKey: "minAmps")
        }
        
        // Post Notification
        NSNotificationCenter.defaultCenter().postNotificationName("SettingsUpdate", object: nil, userInfo: nil)
        
    }
    
    func dismissSettingsViewController(){
        dismissViewControllerAnimated(true) { () -> Void in
            
        }
        
    }
    
    func connectionTypeFilterToggle(connectionType: Int) -> Bool {
        if let _ = connectionTypeIDs.indexOf(connectionType){
            deleteTypeFromConnectionFilterArray(connectionType)
            //connectionTypeIDs.removeAtIndex(foundAtIndex)
            return false
            
        } else {
            connectionTypeIDs.append(connectionType)
            return true
        }
    }

    func deleteTypeFromConnectionFilterArray(connectionType: Int){
        connectionTypeIDs = connectionTypeIDs.filter{$0 != connectionType}
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let section = indexPath.section
        let row = indexPath.row
        
        if (section == 1){
            if (row == 0){
                //Chuko
                if (connectionTypeFilterToggle(connectionIdSchuko)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
            } else if (row == 1) {
                //Chademo
                if (connectionTypeFilterToggle(connectionIdChademo)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }

            } else if (row == 2) {
                // Type 2
                if (connectionTypeFilterToggle(connectionIdType2)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
            } else if (row == 3) {
                // Tesla Supercharger
                if (connectionTypeFilterToggle(connectionIdTeslaSupercharger)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
            }
            
            
        }

    }
    
}
