//
//  DisplayDataOperation.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 10.01.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

import UIKit

class DisplayDataOperation: Operation {
    
    var controller: GroupsController
    
    init(controller: GroupsController) {
        self.controller = controller
    }
    
    override func main() {
        
        guard let parseData = dependencies.first as? ParseDataOperation else { return }
        controller.allGroups = parseData.allGroupsOperation
        controller.tableView.reloadData()
    }
}
