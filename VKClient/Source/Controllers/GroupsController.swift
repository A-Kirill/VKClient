//
//  GroupsController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 16.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift

class GroupsController: UITableViewController {
    
    let vkApi = VKApi()
    var allGroups = [Groups]()
    var allGroupsRealm: Results<Groups>?
    
    var token: NotificationToken?
    
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
        self.allGroups = Database.shared.getRealmGroups()
        // 2) Or from web
        vkApi.getUserGroups(){ [weak self] allGroups in
            self?.allGroups = allGroups
            self?.tableView.reloadData()
        }
        
        //subscribing on changes
        token = allGroupsRealm?.observe { changes in
            switch changes {
            case .error: print("error")
            case .initial(let results): print(results)
            case let .update(results, indexesDelete, indexesInsert, indexesModifications):
                self.insertInTable(indexPath: indexesInsert.map { IndexPath(row: $0, section: 0)})
                self.deleteInTable(indexPath: indexesDelete.map { IndexPath(row: $0, section: 0)})
                self.updateInTable(indexPath: indexesModifications.map { IndexPath(row: $0, section: 0)})
                print(results)
                print(indexesDelete)
                print(indexesInsert)
                print(indexesModifications)
            }
        }

    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell

        cell.nameLabel.text = allGroups[indexPath.row].name

        if let imageURL = URL(string: allGroups[indexPath.row].photo50) {
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
