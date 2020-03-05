//
//  AllGroupsController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 16.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class AllGroupsController: UITableViewController {
    
    let vkApi = VKApi()
    var allGroups = [Groups]()
    //______
    private let viewModelFactory = GroupsViewModelFactory()
    private var viewModels: [GroupsViewModel] = []
    //------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        vkApi.getSearchedGroup(for: "IOS developers"){ [weak self] allGroups in
            guard let self = self else { return }
            self.allGroups = allGroups
            //____
            self.viewModels = self.viewModelFactory.constructViewModels(from: allGroups)
            //----
            self.tableView.reloadData()
        }
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return allGroups.count
        //____
        return viewModels.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "groupCell", for: indexPath) as! GroupCell
//        cell.nameLabel.text = allGroups[indexPath.row].name
//
//        if let imageURL = URL(string: allGroups[indexPath.row].photo50) {
//            DispatchQueue.global().async {
//                let data = try? Data(contentsOf: imageURL)
//                if let data = data {
//                    let image = UIImage(data: data)
//                    DispatchQueue.main.async {
//                        cell.groupImageView.image = image
//                    }
//                }
//            }
//        }
        //____
        cell.configure(with: viewModels[indexPath.row])
        
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


//    var allGroups: [Group] = [
//        Group(name: "VKPay", logo: UIImage(named: "VKPay")),
//        Group(name: "GeekBrains", logo: UIImage(named: "GeekBrains")),
//        Group(name: "Swift", logo: UIImage(named: "Swift")),
//        Group(name: "Mail.ru", logo: UIImage(named: "Mail.ru"))
//    ]
