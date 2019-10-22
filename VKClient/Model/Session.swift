//
//  Session.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 22.10.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

class Session {
    static let instance = Session()
    private init() {}
    
    var token: String = ""
    var userId: Int = 0

}
