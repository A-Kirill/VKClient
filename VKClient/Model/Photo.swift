//
//  Photo.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 31.10.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift

class Photo: Codable {
    let response: PhotoResponse

    init(response: PhotoResponse) {
        self.response = response
    }
}

class PhotoResponse: Codable {
    let count: Int
    let items: [PhotoItem]

    init(count: Int, items: [PhotoItem]) {
        self.count = count
        self.items = items
    }
}

class PhotoItem: Codable {
    let id, albumID, ownerID, userID: Int
    //    let sizes: [Size]
    let text: String
    let date: Int

    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case userID = "user_id"
        case /*sizes,*/ text, date
    }

    init(id: Int, albumID: Int, ownerID: Int, userID: Int, /*sizes: [Size],*/ text: String, date: Int) {
        self.id = id
        self.albumID = albumID
        self.ownerID = ownerID
        self.userID = userID
        //  self.sizes = sizes
        self.text = text
        self.date = date
    }
}

// try aply realm to photos class

//class Photo: Decodable {
//    let response: PhotoResponse
//}
//
//class PhotoResponse: Decodable {
//    let count: Int
//    let items: [PhotoItem]
//}
//
//class PhotoItem: Object, Decodable {
//    @objc dynamic var id: Int = 0
//    @objc dynamic var albumID: Int = 0
//    @objc dynamic var ownerID: Int = 0
//    var sizes: [Size]
//    var text: String
//    var date: Int
//    var likes: Likes
//    var reposts, comments: Comments
//    var canComment: Int
//    var tags: Comments
//
//    enum CodingKeys: String, CodingKey {
//        case id
//        case albumID = "album_id"
//        case ownerID = "owner_id"
//        case sizes, text, date, likes, reposts, comments
//        case canComment = "can_comment"
//        case tags
//    }
//}
//
//class Comments: Decodable {
//    let count: Int
//}
//
//class Likes: Decodable {
//    let userLikes, count: Int
//
//    enum CodingKeys: String, CodingKey {
//        case userLikes = "user_likes"
//        case count
//    }
//}
//
//class Size: Object, Decodable {
//    @objc dynamic var type: String = ""
//    @objc dynamic var url: String = ""
//    @objc dynamic var width: Int = 0
//    @objc dynamic var height: Int = 0
//}
