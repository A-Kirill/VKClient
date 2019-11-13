//
//  UserSettings.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 12.11.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift

class UserSettings: Object {
    @objc dynamic var id = 0
    @objc dynamic var token = ""    
}
