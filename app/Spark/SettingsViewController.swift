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
    @IBOutlet var switchShowDownloadDialog: UISwitch!
    @IBOutlet var switchFastcharge: UISwitch!
    @IBOutlet var switchClustering: UISwitch!
    @IBOutlet var segmentControlMapType: UISegmentedControl!
    @IBOutlet var cellSchuko: UITableViewCell!
    @IBOutlet var cellChademo: UITableViewCell!
    @IBOutlet var cellCCS: UITableViewCell!
    @IBOutlet var cellType2: UITableViewCell!
    @IBOutlet var cellTesla: UITableViewCell!
    @IBOutlet var textFieldAmps: UITextField!
    @IBOutlet var labelCacheSize: UILabel!
    @IBOutlet var buttonDeleteCache: UIButton!
    @IBOutlet var buttonAppVersion: UIButton!
    @IBOutlet var stepperClusteringThreshold: UIStepper!
    @IBOutlet var clusteringThresholdLabel: UILabel!
    
    let connectionIdSchuko = 28
    let connectionIdChademo = 2
    let connectionIdType2 = 25
    let connectionIdTeslaSupercharger = 27
    let connectionIdCCS = 33
    
    var connectionTypeIDs = [Int]()
    
    lazy var dataManager: DataManager = DataManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Register tap gesture recognizer to let the user dismiss on-screen keyboard.
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.tapOutsideTextView(_:)))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        loadUserSettingsToViews()
        getAndLoadCacheSize()
        displayAppVersionString()
    }
    
    func tapOutsideTextView(gesture: UITapGestureRecognizer) {
        textFieldAmps.resignFirstResponder()
    }
    
    @IBAction func cancelButtonClicked(){
        dismissSettingsViewController()
    }
    
    @IBAction func doneButtonClicked(){
        saveUserSettings()
        dismissSettingsViewController()
    }
    
    @IBAction func appVersionButtonClicked(){
        showWhatsNewView()
    }
    
    func showWhatsNewView(){
        // Show Welcome screen
        // Create a new "WelcomeStoryBoard" instance.
        let storyboard = UIStoryboard(name: "WelcomeStoryboard", bundle: nil)
        // Create an instance of the storyboard's initial view controller.
        let controller = storyboard.instantiateViewControllerWithIdentifier("InitialController") as UIViewController
        // Display the new view controller.
        presentViewController(controller, animated: true, completion: nil)
    }
    
    func displayAppVersionString(){
        if let version = NSBundle.mainBundle().infoDictionary?["CFBundleShortVersionString"] as? String {
            self.buttonAppVersion.setTitle(version, forState: .Normal)
        }
    }
    
    func getAndLoadCacheSize(){
        let cacheSizeInMB = dataManager.getDataFilesSize() / 1000000
        labelCacheSize.text = String(format: "%d Mb", cacheSizeInMB)
    }
    
    func loadUserSettingsToViews(){
        UserPreferenceHelper.getClusteringThresholdValue()
        let defaults = NSUserDefaults.standardUserDefaults()
        switchOfflineMode.setOn(defaults.boolForKey("offlineMode"), animated: true)
        switchShowDownloadDialog.setOn(defaults.boolForKey("showDownloadDialog"), animated: true)
        switchFastcharge.setOn(defaults.boolForKey("fastchargeOnly"), animated: true)
        switchClustering.setOn(defaults.boolForKey("useClustering"), animated: true)
        clusteringThresholdLabel.text = String(defaults.integerForKey("clusteringThreshold"))
        stepperClusteringThreshold.value = Double(defaults.integerForKey("clusteringThreshold"))
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
                } else if (idAsInt == connectionIdCCS) {
                    cellCCS.accessoryType = .Checkmark
                }
            }
        }
        
        let ampsMinimumFromSettings = NSUserDefaults.standardUserDefaults().integerForKey("minAmps")
        if (ampsMinimumFromSettings > 0) {
            textFieldAmps.text = String(ampsMinimumFromSettings)
        }
    
        segmentControlMapType.selectedSegmentIndex = NSUserDefaults.standardUserDefaults().integerForKey("mapType")

    }
    
    func saveUserSettings(){
        
        // Store user preferences
        let defaults = NSUserDefaults.standardUserDefaults()
        // Offline Mode
        defaults.setBool(switchOfflineMode.on, forKey: "offlineMode")
        // Show Download Dialog
        defaults.setBool(switchShowDownloadDialog.on, forKey: "showDownloadDialog")
        // Clustering Settings
        defaults.setBool(switchClustering.on, forKey: "useClustering")
        defaults.setInteger(Int(stepperClusteringThreshold.value), forKey: "clusteringThreshold")
        // Fastcharging Only
        defaults.setBool(switchFastcharge.on, forKey: "fastchargeOnly")
        // Map Type
        defaults.setInteger(segmentControlMapType.selectedSegmentIndex, forKey: "mapType")
        // Connection Type IDs
        defaults.setObject(connectionTypeIDs, forKey: "connectionFilterIds")
        // Min Amps
        let minAmps = Int(textFieldAmps.text!)
        if minAmps != nil {
            defaults.setInteger(minAmps!, forKey: "minAmps")
        } else {
            defaults.setInteger(0, forKey: "minAmps")
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
    
    @IBAction func stepperValueChanged(sender: UIStepper) {
        clusteringThresholdLabel.text = Int(sender.value).description
    }
    
    func showSourceCodeOnGitHub(){
        // Send user to the GitHub repo page
        if let url = NSURL(string: "https://github.com/Zyg0te/sparkmap") {
            UIApplication.sharedApplication().openURL(url)
        }
    }
    
    func userWantsToRateApp(){
        UIApplication.sharedApplication().openURL(NSURL(string : "itms-apps://itunes.apple.com/app/id1081587641")!)
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        let section = indexPath.section
        let row = indexPath.row
        
        if (section == 1){
            if (row == 0) {
                //CCS
                if (connectionTypeFilterToggle(connectionIdCCS)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
                }
            if (row == 1) {
                //Chuko
                if (connectionTypeFilterToggle(connectionIdSchuko)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
            } else if (row == 2) {
                //Chademo
                if (connectionTypeFilterToggle(connectionIdChademo)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }

            } else if (row == 3) {
                // Type 2
                if (connectionTypeFilterToggle(connectionIdType2)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
            } else if (row == 4) {
                // Tesla Supercharger
                if (connectionTypeFilterToggle(connectionIdTeslaSupercharger)){
                    cell?.accessoryType = .Checkmark
                } else {
                    cell?.accessoryType = .None
                }
            }
        } else if (section == 4) {
            if (row == 1) {
                showSourceCodeOnGitHub()
            } else if (row == 2) {
                userWantsToRateApp()
            }
        }
    }
}
