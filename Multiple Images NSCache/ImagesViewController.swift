//
//  ImagesViewController.swift
//  Multiple Images NSCache
//
//  Created by Gunveet Singh Dhillon on 2023-08-14.
//

import UIKit

class ImagesViewController: UIViewController {

    @IBOutlet var myCollectionView: UICollectionView!
    
    var imageCacheForCollection = NSCache<NSString, UIImage>()
    var tImages = 0
    
    // Image selected handler closure
        var imageSelectedHandler: ((UIImage) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

}

extension ImagesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tImages
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = myCollectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! MyCollectionViewCell
        if let image = imageCacheForCollection.object(forKey: NSString(string: "\(indexPath.row)"))
        {
            cell.myImageView.image = image
            cell.myImageView.contentMode = .scaleToFill
            cell.myImageView.layer.cornerRadius = 25
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let size = (collectionView.frame.size.width-10)/2
        return CGSize(width: size, height: size)
    }
    
    // didSelectItemAt method to use the imageSelectedHandler
        func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let selectedImage = imageCacheForCollection.object(forKey: NSString(string: "\(indexPath.item)")) {
                imageSelectedHandler?(selectedImage)
            }
        }
}
