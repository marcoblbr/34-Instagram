//
//  TimelineViewController.swift
//  Raiz Pic
//
//  Created by Marco on 8/17/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit
import Parse

class TimelineViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var parseModel = ParseModel.singleton
    
    var titles     : [String]  = []
    var usernames  : [String]  = []
    var images     : [UIImage] = []
    var imageFiles : [PFFile]  = []
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func buttonBack (sender: AnyObject) {
        dismissViewControllerAnimated (true, completion: nil)
    }
    
    func numberOfSectionsInTableView (tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView (tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    // função que atualiza todas as células com o texto correto
    func tableView (tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        
        let timelineCell = tableView.dequeueReusableCellWithIdentifier ("cell") as! TimelineCellViewController

        // para desativar o clique na célula
        timelineCell.selectionStyle = UITableViewCellSelectionStyle.None
        
        timelineCell.labelTitle.text    = titles    [indexPath.row]
        timelineCell.labelUsername.text = usernames [indexPath.row]
        
        imageFiles [indexPath.row].getDataInBackgroundWithBlock () {
            
            (imageData: NSData?, error: NSError?) -> Void in
            
            if error == nil {
                if let imageData = imageData {
                    let image = UIImage (data: imageData)
                    
                    timelineCell.imagePosted.image = image
                }
            }
        }
        
        return timelineCell
    }
    
    // função que é necessária onde é colocado o tamanho de cada linha
    // (definido no próprio storyboard)
    func tableView (tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 227
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // quando eu dou um dismiss e entro novamente aqui, a função viewDidLoad é
        // chamada novamente, por isso que funciona zerar os vetores aqui
        titles     = []
        usernames  = []
        images     = []
        imageFiles = []
        
        var getFollowedUsersQuery = PFQuery (className: "Follow")
        
        // pega apenas o meu próprio usuário
        getFollowedUsersQuery.whereKey ("user",   equalTo: (PFUser.currentUser ()?.username)!)
        getFollowedUsersQuery.whereKey ("status", equalTo: true)
        
        // pegou os usuários, agora descobre quais desse users tem postagens
        getFollowedUsersQuery.findObjectsInBackgroundWithBlock () {
            
            (objects: [AnyObject]?, error: NSError?) -> Void in
            
            if let error = error {
                // There was an error
                
            } else {
                var followedUser = ""
                
                // objects has all the Posts the current user liked.
                
                if let objects = objects as? [PFObject] {
                    
                    // table Follow no Parse
                    for object in objects {
                        // pega cada usuário sendo seguido nocampo follow do parse na table Follow
                        followedUser = object ["follow"] as! String
       
                        // com cada nome, pega as postagens desse user
                        var query = PFQuery (className: "Images")
                        
                        query.whereKey ("username", equalTo: followedUser)
                        
                        query.findObjectsInBackgroundWithBlock {
                            
                            (objects: [AnyObject]?, error: NSError?) -> Void in
                            
                            if error != nil {
                                // Log details of the failure
                                println ("Error: \(error!) \(error!.userInfo!)")
                                
                            } else {
                                // The find succeeded.
                                // Do something with the found objects
                                if let objects = objects as? [PFObject] {
                                    
                                    for object in objects {
                                        self.titles.append     (object ["title"]    as! String)
                                        self.usernames.append  (object ["username"] as! String)
                                        self.imageFiles.append (object ["image"]    as! PFFile)
                                        
                                        self.tableView.reloadData ()
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
