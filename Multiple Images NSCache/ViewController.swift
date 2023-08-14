//
//  ViewController.swift
//  Multiple Images NSCache
//
//  Created by Gunveet Singh Dhillon on 2023-08-14.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var LoadingWaitLabel: UILabel!
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    var dogAllData:DogData?
    var dogImageAllLinks = [String]()
    var imageToCache = NSCache<NSString,UIImage>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        activityIndicator.hidesWhenStopped = true
    }
    
    func fetchData()
    {
        let url = URL(string: "https://dog.ceo/api/breed/hound/images")
        let task = URLSession.shared.dataTask(with: url!, completionHandler:  {
            (data, response, error) in
            guard let data = data, error == nil else
            {
                print("Error Occured While Accessing Data")
                return
            }
            var dogObject:DogData?
            do
            {
                dogObject = try JSONDecoder().decode(DogData.self, from: data)
            }
            catch
            {
                print("Error While Decoding JSON into Swift Structure \(error)")
            }
            self.dogAllData = dogObject
            self.dogImageAllLinks = self.dogAllData!.message
            let totalImages = self.dogImageAllLinks.count
            var i = 0
            var totalDownloadedImage:Int = 0
            while(i<totalImages)
            {
                let urlString = URL(string: self.dogImageAllLinks[i])
                self.downloadImage(from: urlString!, counter: String(i), completion: {
                    (value) in
                    if (value == 1)
                    {
                        totalDownloadedImage = totalDownloadedImage + 1
                    }
                    DispatchQueue.main.async {
                        if totalDownloadedImage == totalImages
                        {
                            self.LoadingWaitLabel.text = "All Images Downloaded Successfully"
                            self.activityIndicator.stopAnimating()
                        }
                    }
                })
                i = i + 1
            }
            
        })
                      
                      task.resume()
                      
    }
                      
                      func downloadImage(from url:URL, counter:String, completion: @escaping (_ result:Int) -> ())
                      {
            let dataTask = URLSession.shared.dataTask(with: url, completionHandler: {
                (data, response, error) in
                guard let httpURLResponse = response as? HTTPURLResponse, httpURLResponse.statusCode == 200,
                      let mimeType = response?.mimeType, mimeType.hasPrefix("image"),
                      let data = data, error == nil,
                      let image = UIImage(data: data)
                else
                {
                    return
                }
                self.imageToCache.setObject(image, forKey: NSString(string: counter))
                DispatchQueue.main.async {
                    self.LoadingWaitLabel.text = "Downloading Image \(counter)... Wait"
                }
                completion(1)
            })
            dataTask.resume()
        }

    @IBAction func clickDownloadImages(_ sender: Any) {
            
            fetchData()
            activityIndicator.startAnimating()
    }
    
    @IBAction func showImagesCollectionView(_ sender: Any) {
            let vc = storyboard?.instantiateViewController(withIdentifier: "showImages") as? ImagesViewController
            vc?.imageCacheForCollection = imageToCache
            vc?.tImages = dogImageAllLinks.count
            vc?.title = "Images From Cache"
            navigationController?.pushViewController(vc!, animated: true)
    }
}

            
