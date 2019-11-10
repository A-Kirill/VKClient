//
//  User.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 18.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift

struct User {
    var name = String()
    var avatar: UIImage?
    var photo: [UIImage?]
}

class FriendResponseWrapped: Decodable {
    let response: FriendResponse
}

class FriendResponse: Decodable {
    let count: Int = 0
    let items: [Friend]
}

class Friend: Object, Decodable {
    @objc dynamic var id: Int = 0
    @objc dynamic var firstName: String = ""
    @objc dynamic var lastName: String = ""
    @objc dynamic var photo: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case photo = "photo_50"
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
        self.photo = try values.decode(String.self, forKey: .photo)
    }
}
