//
//  FriendsController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 16.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift
import FirebaseAuth
import FirebaseDatabase
import PromiseKit

class FriendsController: UITableViewController {
    
    let vkApi = VKApi()
    var allFriendsRealm: Results<Friend>!
    lazy var photoService = PhotoService(container: self.tableView)
    
    var token: NotificationToken?
    
    override func viewDidLoad() {      
        super.viewDidLoad()

        // 1) request data from Realm
        allFriendsRealm = DatabaseRealm.shared.getRealmFriends()
        
        animateList()
        
        // 2) Or from web
 //       vkApi.getFriends(){ allFriends in }
        
        // 3) request data with PromiseKit
        firstly {
            vkApi.getUserPromiseKit()
        }.done { [weak self] allFriends in
                guard let self = self else { return }
                self.tableView.reloadData()
                DatabaseRealm.shared.saveFriendData(allFriends)
        }.catch { error in
                print(error)
        }

        
        //subscribing on changes
        token = allFriendsRealm?.observe { changes in
            switch changes {
            case .error: print("error")
            case .initial(let results):
                self.tableView.reloadData()
                print(results)
            case let .update(results, indexesDelete, indexesInsert, indexesModifications):
                self.tableView.reloadData()
//                self.insertInTable(indexPath: indexesInsert.map { IndexPath(row: $0, section: 0)})
//                self.deleteInTable(indexPath: indexesDelete.map { IndexPath(row: $0, section: 0)})
//                self.updateInTable(indexPath: indexesModifications.map { IndexPath(row: $0, section: 0)})
//                print(results)
//                print(indexesDelete)
//                print(indexesInsert)
//                print(indexesModifications)
            }
        }
    }
    
    func insertInTable(indexPath: [IndexPath]){
        tableView.beginUpdates()
        tableView.insertRows(at: indexPath, with: .none)
        tableView.endUpdates()
    }
    
    func deleteInTable(indexPath: [IndexPath]){
        tableView.beginUpdates()
        tableView.deleteRows(at: indexPath, with: .none)
        tableView.endUpdates()
    }
    
    func updateInTable(indexPath: [IndexPath]){
        tableView.beginUpdates()
        tableView.reloadRows(at: indexPath, with: .none)
        tableView.endUpdates()
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

    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
 //       return 1
        return allFriendsRealm.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell

        cell.friendNameLabel.text = allFriendsRealm[indexPath.row].firstName + " " + allFriendsRealm[indexPath.row].lastName
        
        // load from cache or web (new version):
        cell.friendImageView.image = photoService.photo(atIndexpath: indexPath, byUrl: allFriendsRealm[indexPath.row].photo)
        
        // load from web (old version). convert String URL to UIImage
//        if let imageURL = URL(string: allFriendsRealm[indexPath.row].photo) {
//            DispatchQueue.global().async {
//                let data = try? Data(contentsOf: imageURL)
//                if let data = data {
//                    let image = UIImage(data: data)
//                    DispatchQueue.main.async {
//                        cell.friendImageView.image = image
//                    }
//                }
//            }
//        }

        return cell
    }

    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // sent info to PhotosController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "photosSegue" {
            guard let destinationController = segue.destination as? PhotosController else {return}
            
            let index = tableView.indexPathForSelectedRow?.row ?? 0
            if allFriendsRealm.count > index {
                let chosenFriend = allFriendsRealm[index]
                print(chosenFriend.id)

                destinationController.selectedUserId = chosenFriend.id
                destinationController.navigationItem.title = chosenFriend.firstName + " photos"
            }
        }
    }
}

extension String {
    subscript (i: Int) -> Character {
        return self[index(startIndex, offsetBy: i)]
    }
}

//        //FIREBASE TEST:
//        //Register user in Firebase:
//        Auth.auth().createUser(withEmail: "kirill@mail.ru", password: "543210") { (result, error) in
//            print(result.debugDescription)
//            print(error.debugDescription)
//        }
//        Auth.auth().createUser(withEmail: "developer@mail.ru", password: "543210") { (result, error) in }
//        //Authorisation
//        Auth.auth().signIn(withEmail: "kirill@mail.ru", password: "543210") { (result, error) in
//            print(result?.user.uid)
//        }
//
//        //FirebaseDatabase :
//        let ref = Database.database().reference(withPath: "users/TestUser/addedGroups") //"users"
//        ref.observe(.value/*.childAdded*/) { snapshot in
//            print("-----------------------")
//            print(snapshot.value)
//            print("-----------------------")
//        }


// for course 1
//    var allFriends: [User] = [
//        User(name: "Cook", avatar: UIImage(named: "Cook"), photo: [UIImage(named: "c1"), UIImage(named: "Cook")]),
//        User(name: "Federighi", avatar: UIImage(named: "Federighi"), photo: [UIImage(named: "f1"), UIImage(named: "Federighi")]),
//        User(name: "Ive", avatar: UIImage(named: "Ive"), photo: [UIImage(named: "i1"), UIImage(named: "Ive")]),
//        User(name: "Jobs", avatar: UIImage(named: "Jobs"), photo: [UIImage(named: "j1"), UIImage(named: "j2"), UIImage(named: "j3"), UIImage(named: "j4")]),
//        User(name: "Wozniak", avatar: UIImage(named: "Wozniak"), photo: [UIImage(named: "w1"), UIImage(named: "Wozniak")])
//    ]
