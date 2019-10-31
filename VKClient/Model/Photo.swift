//
//  Photo.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 31.10.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

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
