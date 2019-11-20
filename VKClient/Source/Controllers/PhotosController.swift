//
//  PhotosController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 16.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class PhotosController: UICollectionViewController {
    
    private let reuseIdentifier = "photoCell"
 
//    var image: [UIImage?] = [UIImage(named: "empty")]
    var photosFriend = [PhotoItem]()
    var urlChosenFriends = [String]()
    var likes = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return urlChosenFriends.count
//        return image.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        if let imageURL = URL(string: urlChosenFriends[indexPath.item]) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.photoImageView.image = image
                    }
                }
            }
        }
 //       cell.photoImageView.image = image[indexPath.item]
        cell.countLikeLabel.text = String(likes[indexPath.item])
    
        return cell
    }
}
