//
//  ParseDataOperation.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 10.01.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

import UIKit
import Alamofire

class ParseDataOperation: Operation {
    
    var allGroupsOperation = [Groups]()
    
    override func main() {
        guard let getDataOperation = dependencies.first/*(where: { $0 is FetchDataOperation })*/ as? FetchDataOperation,
        let data = getDataOperation.data,
            let responseData = try? JSONDecoder().decode(GroupResponseWrapped.self, from: data) else { return }
        allGroupsOperation = responseData.response.items
    }
}

