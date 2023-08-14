//
//  ImageDisplayViewController.swift
//  Multiple Images NSCache
//
//  Created by Gunveet Singh Dhillon on 2023-08-14.
//

import UIKit

class ImageDisplayViewController: UIViewController {
    
    @IBOutlet var imageView: UIImageView!
    
    var image: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        imageView.image = image
        imageView.contentMode = .scaleAspectFit

    }


}
