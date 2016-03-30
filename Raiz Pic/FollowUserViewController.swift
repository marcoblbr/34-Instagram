//
//  TableViewController.swift
//  Raiz Pic
//
//  Created by Marco Linhares on 8/15/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit
import Parse

class FollowUserViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var parseModel = ParseModel.singleton
    
    var refresher : UIRefreshControl!
    
    @IBOutlet weak var tableView: UITableView!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return listOfCheckedUsers.count
    }
    
    // função que atualiza todas as células com o texto correto
    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCellWithIdentifier ("cell") as! UITableViewCell
        
        cell.textLabel!.text = listOfCheckedUsers [indexPath.row].0

        if listOfCheckedUsers [indexPath.row].1 == true {
            cell.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell.accessoryType = UITableViewCellAccessoryType.None
        }
        
        return cell
    }

    // função que é chamada quando uma célula é clicada
    func tableView (tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        let cell = tableView.cellForRowAtIndexPath (indexPath)
        
        listOfCheckedUsers [indexPath.row].1 = !listOfCheckedUsers [indexPath.row].1

        if listOfCheckedUsers [indexPath.row].1 == true {
            cell!.accessoryType = UITableViewCellAccessoryType.Checkmark
        } else {
            cell!.accessoryType = UITableViewCellAccessoryType.None
        }
        
        parseModel.invertUserStatus (currentUser, followedUser : listOfCheckedUsers [indexPath.row].0, status: listOfCheckedUsers [indexPath.row].1) {
            
            (result, error) -> Void in
        }
    }

    func refresh () {
        refresher.endRefreshing ()
    }
    
    override func viewDidLoad () {
        super.viewDidLoad ()
        // Do any additional setup after loading the view, typically from a nib.
        
        // adiciona o refresh na TableView
        refresher = UIRefreshControl ()
        
        refresher.attributedTitle = NSAttributedString (string: "Pull to refresh")
        
        // função que é chamada quando é dado refresh
        refresher.addTarget (self, action: "refresh", forControlEvents: UIControlEvents.ValueChanged)
        
        tableView.addSubview (refresher)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear (animated)
    }
    
    override func didReceiveMemoryWarning () {
        super.didReceiveMemoryWarning ()
        // Dispose of any resources that can be recreated.
    }
}
