//
//  FriendsController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 16.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class FriendsController: UITableViewController {
    
//    var allFriends: [User] = [
//        User(name: "Cook", avatar: UIImage(named: "Cook"), photo: [UIImage(named: "c1"), UIImage(named: "Cook")]),
//        User(name: "Federighi", avatar: UIImage(named: "Federighi"), photo: [UIImage(named: "f1"), UIImage(named: "Federighi")]),
//        User(name: "Ive", avatar: UIImage(named: "Ive"), photo: [UIImage(named: "i1"), UIImage(named: "Ive")]),
//        User(name: "Jobs", avatar: UIImage(named: "Jobs"), photo: [UIImage(named: "j1"), UIImage(named: "j2"), UIImage(named: "j3"), UIImage(named: "j4")]),
//        User(name: "Wozniak", avatar: UIImage(named: "Wozniak"), photo: [UIImage(named: "w1"), UIImage(named: "Wozniak")])
//    ]
    let vkApi = VKApi()
    var allFriends = [Friend]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkApi.getFriends(){ [weak self] allFriends in
            self?.allFriends = allFriends
            self?.tableView.reloadData()
        }
    }
    
    
    //Adding animations on cells:
    
    override func viewWillAppear(_ animated: Bool) {
        animateList()
    }
    
    func animateList() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableWidth: CGFloat = tableView.bounds.size.width
        
        for i in cells {
            let cell: UITableViewCell = i as UITableViewCell
            cell.transform = CGAffineTransform(translationX: tableWidth, y: 0)
        }
        
        var index = 0
        
        for j in cells {
            let cell: UITableViewCell = j as UITableViewCell
            UIView.animate(withDuration: 1,
                           delay: 0.05 * Double(index),
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           animations: {
                            cell.transform = CGAffineTransform(translationX: 0, y: 0)
            },
                           completion: nil)
            index += 1
        }
    }
    
    
    // MARK: - Table view data source

//    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
//        return String(allFriends[section].name[0])
//    }
    
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return allFriends.count
    }
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell

//        cell.friendNameLabel.text = allFriends[indexPath.section].name
       // cell.friendImageView?.image = allFriends[indexPath.section].avatar
        cell.friendNameLabel.text = allFriends[indexPath.section].firstName + " " + allFriends[indexPath.section].lastName
        
        //String URL to UIImage
        if let imageURL = URL(string: allFriends[indexPath.section].photo) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.friendImageView.image = image
                    }
                }
            }
        }
        
        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // sent info to PhotosController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photosSegue" {
            guard let destinationController = segue.destination as? PhotosController else {return}
            
            let index = tableView.indexPathForSelectedRow?.section ?? 0
            if allFriends.count > index {
                let friend = allFriends[index]
//                destinationController.navigationItem.title = friend.name
//                destinationController.image = friend.photo
                destinationController.navigationItem.title = friend.firstName
            }
        }
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

