//
//  GroupsController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 16.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class GroupsController: UITableViewController {
    
    let vkApi = VKApi()
    var allGroups = [Groups]()
    var allGroupsRealm: Results<Groups>!
    
    var token: NotificationToken?
    
    private let myQueue: OperationQueue = {
        let queue = OperationQueue()
        return queue
    }()
    
    @IBAction func addGroups(segue: UIStoryboardSegue) {
        if segue.identifier == "addGroup" {
            guard let allGroupController = segue.source as? AllGroupsController  else { return }
            guard let indexPath = allGroupController.tableView.indexPathForSelectedRow else {return}

            let group = allGroupController.allGroups[indexPath.row]
            if !allGroups.contains(where: {$0.name == group.name}) {
                allGroups.append(allGroupController.allGroups[indexPath.row])
                tableView.insertRows(at: [IndexPath(row: allGroups.count - 1, section: 0)], with: .fade)
            }
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // 1) request data from Realm
        allGroupsRealm = DatabaseRealm.shared.getRealmGroups()
//        // 2) Or from web
//        vkApi.getUserGroups(){ allGroups in }
        
        // using Operation to fetch Data from web
        getDataOperation()
        
        //subscribing on changes
        token = allGroupsRealm?.observe { changes in
            switch changes {
            case .error: print("error")
            case .initial(let results):
                self.tableView.reloadData()
//                print(results)
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
    

    func getDataOperation() {
        
        let url = "https://api.vk.com/method/groups.get"
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "extended": "1",
            "access_token": Session.instance.token,
            "v": "5.102"
        ]
        
        let request = Alamofire.request(url, method: .get, parameters: parameters)
        let fetchDataOperation = FetchDataOperation(request: request)
        myQueue.addOperation(fetchDataOperation)
        
        let parseDataOperation = ParseDataOperation()
        parseDataOperation.addDependency(fetchDataOperation)
        myQueue.addOperation(parseDataOperation)
        
        let saveOperation = SaveToRealmOperation()
        saveOperation.addDependency(parseDataOperation)
        myQueue.addOperation(saveOperation)
        
        let displayDataOperation = DisplayDataOperation(controller: self)
        displayDataOperation.addDependency(saveOperation)
        OperationQueue.main.addOperation(displayDataOperation)

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroupsRealm.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell

        cell.nameLabel.text = allGroupsRealm[indexPath.row].name

        if let imageURL = URL(string: allGroupsRealm[indexPath.row].photo50) {
            DispatchQueue.global().async {
                let data = try? Data(contentsOf: imageURL)
                if let data = data {
                    let image = UIImage(data: data)
                    DispatchQueue.main.async {
                        cell.groupImageView.image = image
                    }
                }
            }
        }
        return cell
    }
    
    // delegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            allGroups.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
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
}
