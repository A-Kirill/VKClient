//
//  News.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 29.09.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

struct NewsResponseWrapped: Decodable {
    let response: NewsResponse
}

struct NewsResponse: Decodable {
    let items: [NewsModel]
    let profiles: [ProfileNews]
    let groups: [GroupNews]
    let nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

struct NewsModel: Decodable {
    let type: String?
    let sourceID, date: Int?
    let postType, text: String?
    let markedAsAds: Int?
    let attachments: [Attachment]?
    let postSource: PostSource?
    let comments: CommentsNews?
    let likes: LikesNews?
    let reposts: Reposts?
    let views: Views?
    let isFavorite: Bool?
    let postID: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case sourceID = "source_id"
        case date
        case postType = "post_type"
        case text
        case markedAsAds = "marked_as_ads"
        case attachments
        case postSource = "post_source"
        case comments, likes, reposts, views
        case isFavorite = "is_favorite"
        case postID = "post_id"
    }
}

struct GroupNews: Decodable {
    let id: Int
    let name, screenName: String?
    let isClosed: Int?
    let type: String?
    let isAdmin, isMember, isAdvertiser: Int?
    let photo50, photo100, photo200: String?
    
    enum CodingKeys: String, CodingKey {
        case id, name
        case screenName = "screen_name"
        case isClosed = "is_closed"
        case type
        case isAdmin = "is_admin"
        case isMember = "is_member"
        case isAdvertiser = "is_advertiser"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case photo200 = "photo_200"
    }
}

struct Attachment: Decodable {
    let type: String?
    let doc: Doc?
    let photo: PhotoFromNews?
}

struct PhotoFromNews: Decodable {
    let sizes: [PhotoSize]
}

struct PhotoSize: Decodable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}

struct Doc: Decodable {
    let id, ownerID: Int?
    let title: String?
    let size: Int
    let ext: String?
    let url: String?
    let date, type: Int
    let preview: Preview?
    let accessKey: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case ownerID = "owner_id"
        case title, size, ext, url, date, type, preview
        case accessKey = "access_key"
    }
}

struct Preview: Decodable {
    let photo: Photo?
    let video: Video?
}

struct PhotoNews: Decodable {
    let sizes: [Video]
}

struct Video: Decodable {
    let src: String?
    let width, height: Int
    let type: String?
    let fileSize: Int?
    
    enum CodingKeys: String, CodingKey {
        case src, width, height, type
        case fileSize = "file_size"
    }
}

struct CommentsNews: Decodable {
    let count, canPost: Int?
    let groupsCanPost: Bool?
    
    enum CodingKeys: String, CodingKey {
        case count
        case canPost = "can_post"
        case groupsCanPost = "groups_can_post"
    }
}

struct LikesNews: Decodable {
    let count, userLikes, canLike, canPublish: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case userLikes = "user_likes"
        case canLike = "can_like"
        case canPublish = "can_publish"
    }
}

struct PostSource: Decodable {
    let type: String?
}

struct Reposts: Decodable {
    let count, userReposted: Int
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

struct Views: Decodable {
    let count: Int
}

struct ProfileNews: Decodable {
    let id: Int
    let firstName, lastName: String?
    let isClosed, canAccessClosed: Bool?
    let sex: Int
    let screenName: String?
    let photo50, photo100: String?
    let online: Int?
    let onlineInfo: OnlineInfo?
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case isClosed = "is_closed"
        case canAccessClosed = "can_access_closed"
        case sex
        case screenName = "screen_name"
        case photo50 = "photo_50"
        case photo100 = "photo_100"
        case online
        case onlineInfo = "online_info"
    }
}

struct OnlineInfo: Decodable {
    let visible: Bool
    let lastSeen: Int?
    let appID: Int?
    let isMobile: Bool?
    
    enum CodingKeys: String, CodingKey {
        case visible
        case lastSeen = "last_seen"
        case appID = "app_id"
        case isMobile = "is_mobile"
    }
}



//Model for previous cours
struct News {
    var name = String()
    var date = String()
    var avatar: UIImage?
    var image: UIImage?
    var description = String()
}
