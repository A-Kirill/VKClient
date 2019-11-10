//
//  Group.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 18.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift

class GroupResponseWrapped: Decodable {
    let response: GroupResponse
}

class GroupResponse: Decodable {
    let count: Int
    let items: [Groups]
}

class Groups: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var name: String = ""
    @objc dynamic var screenName: String = ""
    @objc dynamic var isClosed: Int = 0
    @objc dynamic var type: String = ""
    @objc dynamic var isAdmin: Int = 0
    @objc dynamic var isMember: Int = 0
    @objc dynamic var isAdvertiser: Int = 0
    @objc dynamic var photo50: String = ""
    
        enum CodingKeys: String, CodingKey {
            case id, name
            case screenName = "screen_name"
            case isClosed = "is_closed"
            case type
            case isAdmin = "is_admin"
            case isMember = "is_member"
            case isAdvertiser = "is_advertiser"
            case photo50 = "photo_50"
        }
}
//    class GroupResponseWrapped: Codable {
//        let response: GroupResponse
//
//        init(response: GroupResponse) {
//            self.response = response
//        }
//    }
//
//    class GroupResponse: Codable {
//        let count: Int
//        let items: [Groups]
//
//        init(count: Int, items: [Groups]) {
//            self.count = count
//            self.items = items
//        }
//    }
//
//    class Groups: Codable {
//        let id: Int
//        let name, screenName: String
//        let isClosed: Int
//        let type: String
//        let isAdmin, isMember, isAdvertiser: Int
//        let photo50, photo100, photo200: String
//
//        enum CodingKeys: String, CodingKey {
//            case id, name
//            case screenName = "screen_name"
//            case isClosed = "is_closed"
//            case type
//            case isAdmin = "is_admin"
//            case isMember = "is_member"
//            case isAdvertiser = "is_advertiser"
//            case photo50 = "photo_50"
//            case photo100 = "photo_100"
//            case photo200 = "photo_200"
//        }
//
//        init(id: Int, name: String, screenName: String, isClosed: Int, type: String, isAdmin: Int, isMember: Int, isAdvertiser: Int, photo50: String, photo100: String, photo200: String) {
//            self.id = id
//            self.name = name
//            self.screenName = screenName
//            self.isClosed = isClosed
//            self.type = type
//            self.isAdmin = isAdmin
//            self.isMember = isMember
//            self.isAdvertiser = isAdvertiser
//            self.photo50 = photo50
//            self.photo100 = photo100
//            self.photo200 = photo200
//        }
//}

//model for 1st course:
struct Group {
    var name = String()
    var logo : UIImage?
}
