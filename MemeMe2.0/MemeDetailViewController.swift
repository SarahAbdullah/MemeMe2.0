//
//  MemeDetailViewController.swift
//  MemeMe2.0
//
//  Created by Sarah on 11/29/18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import UIKit

class MemeDetailViewController: UIViewController {

    var meme :Meme!
    @IBOutlet weak var memeImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        memeImage.image = meme.memedImage 
    }
    

}
 
