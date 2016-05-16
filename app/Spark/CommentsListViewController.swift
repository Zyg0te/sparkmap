//
//  CommentsListViewController.swift
//  SparkMap
//
//  Created by Edvard Holst on 16/05/16.
//  Copyright © 2016 Zygote Labs. All rights reserved.
//

import UIKit

class CommentsListViewController: UIViewController, UITableViewDelegate, UINavigationControllerDelegate {
    
    // Outlets
    @IBOutlet var chargerTitleLabel: UILabel!
    @IBOutlet var chargerCommentsTableView: UITableView!
    
    var charger: ChargerPrimary?
    var comments: [Comment] = [Comment]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        // Configure TableView
        let nib = UINib(nibName: "CommentTableViewCell", bundle: nil)
        chargerCommentsTableView.registerNib(nib, forCellReuseIdentifier: "net.zygotelabs.commentcell")
        chargerCommentsTableView.tableFooterView = UIView(frame: CGRectZero)

        // Do any additional setup after loading the view.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("net.zygotelabs.commentcell", forIndexPath: indexPath) as! CommentTableViewCell
        
        cell.commentTextLabel?.text = (comments[indexPath.row] as Comment).comment
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
