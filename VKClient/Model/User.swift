//
//  User.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 18.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

struct User {
    var name = String()
    var avatar: UIImage?
    var photo: [UIImage?]
}


class FriendResponse: Decodable {
    let items: [Friend]

    enum CodingKeys: String, CodingKey {
        case items
    }
}

class Friend: Decodable {
    var id: Int = 0
    var firstName: String = ""
    var lastName: String = ""

    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
    }

    convenience required init(from decoder: Decoder) throws {
        self.init()
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.id = try values.decode(Int.self, forKey: .id)
        self.firstName = try values.decode(String.self, forKey: .firstName)
        self.lastName = try values.decode(String.self, forKey: .lastName)
    }
}
