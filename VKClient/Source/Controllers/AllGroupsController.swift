//
//  AllGroupsController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 16.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController {
    
    var allGroups: [Group] = [
        Group(name: "VKPay", logo: UIImage(named: "VKPay")),
        Group(name: "GeekBrains", logo: UIImage(named: "GeekBrains")),
        Group(name: "Swift", logo: UIImage(named: "Swift")),
        Group(name: "Mail.ru", logo: UIImage(named: "Mail.ru"))
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return allGroups.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
        cell.nameLabel.text = allGroups[indexPath.row].name
        cell.groupImageView?.image = allGroups[indexPath.row].logo
        return cell
    }
    
// delegate
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    
    // Override to support editing the table view.
//    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
//        if editingStyle == .delete {
//            allGroups.remove(at: indexPath.row)
//            tableView.deleteRows(at: [indexPath], with: .fade)
//        }
//    }
//    

 

}
