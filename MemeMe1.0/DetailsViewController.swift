//
//  DetailsViewController.swift
//  MemeMe1.0
//
//  Created by Ramon Yepez on 3/17/21.
//

import UIKit

class DetailsViewController: UIViewController {
//outlet to display image
    @IBOutlet weak var detailMemeImage: UIImageView!
    //property to story image sent
    var imageToDisplay: UIImage!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //setting the image to that one that we sent from the previous controller
        detailMemeImage?.image = 
            imageToDisplay
        // Do any additional setup after loading the view.
    }
    
}
