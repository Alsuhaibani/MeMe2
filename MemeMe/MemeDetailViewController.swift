//
//  MemeDetailViewController.swift
//  MemeMe
//
//  Created by Alsuhaibani on 18/12/2018.
//  Copyright © 2018 Alsuhaibani. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {
    @IBOutlet weak var memeDetails: UIImageView!
    
    var meme: Meme!
    var memesImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        // Do any additional setup after loading the view.
        if let memeimage = memesImage {
            memeDetails.image = memeimage
        }
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
       
        
    }
}
