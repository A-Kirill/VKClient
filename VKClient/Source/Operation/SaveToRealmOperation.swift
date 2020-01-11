//
//  SaveToRealmOperation.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 11.01.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

import UIKit

class SaveToRealmOperation: Operation {
    override func main() {
        guard let parseOperation = dependencies.first as? ParseDataOperation else { return }
        DatabaseRealm.shared.saveGroupsData(parseOperation.allGroupsOperation)
    }
}
