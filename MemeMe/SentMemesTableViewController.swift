//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Alsuhaibani on 18/12/2018.
//  Copyright © 2018 Alsuhaibani. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {
   // @IBOutlet weak var tableView: UITableView!
    var memes: [Meme]! {
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        return appDelegate.memes
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source

    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 100.0
    }
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return memes.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memesTableCell", for: indexPath) as! SentMemesTableViewCell

        // Configure the cell...
        let meme = memes[indexPath.row]
        cell.memedImage.image = meme.memedImage
        cell.labelCell.text = (meme.top)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        //Get the object of MemeDetailViewController from the Storyboard
        let meme = memes[(indexPath as NSIndexPath).row]
        let memeImage = meme.memedImage
        let memeDetails = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        memeDetails.memesImage = memeImage
       
        
        
        
        //Pass the Meme Date
        memeDetails.meme = self.memes[(indexPath as NSIndexPath).row]
        
        //Push to the scene
        self.navigationController!.pushViewController(memeDetails, animated: true)
     
    }
    
}
