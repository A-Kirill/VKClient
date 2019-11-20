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
    
    let vkApi = VKApi()
 
    var selectedUserId = Int()
    var selectedUserPhoto = [PhotoItem]()
    var urlsChosenFriends = [String]()
    var photosLike = [Int]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkApi.getUserPhoto(for: "\(selectedUserId)"){ [weak self] selectedUserPhoto in
            self?.selectedUserPhoto = selectedUserPhoto
            self?.urlsChosenFriends = []
            for i in selectedUserPhoto {
                self?.photosLike.append(i.likes.count)
                for j in i.sizes {
                    if j.type == "x" {
                        self?.urlsChosenFriends.append(j.url)
                        print(j.url)
                    }
                }
            }
            self?.collectionView.reloadData()
        }
    }

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return urlsChosenFriends.count
//        return image.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PhotoCell
        if let imageURL = URL(string: urlsChosenFriends[indexPath.item]) {
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
        cell.countLikeLabel.text = String(photosLike[indexPath.item])
    
        return cell
    }
    
    //    var image: [UIImage?] = [UIImage(named: "empty")]
}
