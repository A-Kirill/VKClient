//
//  PhotoNews.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 24.12.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit

struct PhotoNewsWrapped: Decodable {
    let response: PhotoNewsResponse
}

struct PhotoNewsResponse: Decodable {
    let items: [PhotoResponseItem]
    let profiles: [Profile]
    let groups: [GroupPhotoNews]
    let nextFrom: String?
    
    enum CodingKeys: String, CodingKey {
        case items, profiles, groups
        case nextFrom = "next_from"
    }
}

struct PhotoResponseItem: Decodable {
    let type: String?
    let sourceID, date: Int?
    let photos: Photos?
    let postID: Int?
    
    enum CodingKeys: String, CodingKey {
        case type
        case sourceID = "source_id"
        case date, photos
        case postID = "post_id"
    }
}

struct Photos: Decodable {
    let count: Int
    let items: [PhotosItem]
}

// MARK: - PhotosItem
struct PhotosItem: Decodable {
    let id, albumID, ownerID: Int?
    let sizes: [PSize]?
    let text: String?
    let date: Int?
    let accessKey: String?
    let likes: PLikes?
    let reposts: PReposts?
    let comments: PComments?
    let canComment, canRepost: Int?
    
    enum CodingKeys: String, CodingKey {
        case id
        case albumID = "album_id"
        case ownerID = "owner_id"
        case sizes, text, date
        case accessKey = "access_key"
        case likes, reposts, comments
        case canComment = "can_comment"
        case canRepost = "can_repost"
    }
}

// MARK: - Comments
struct PComments: Decodable {
    let count: Int?
}

// MARK: - Likes
struct PLikes: Decodable {
    let userLikes, count: Int?
    
    enum CodingKeys: String, CodingKey {
        case userLikes = "user_likes"
        case count
    }
}

// MARK: - Reposts
struct PReposts: Decodable {
    let count, userReposted: Int?
    
    enum CodingKeys: String, CodingKey {
        case count
        case userReposted = "user_reposted"
    }
}

// MARK: - Size
struct PSize: Decodable {
    let type: String?
    let url: String?
    let width, height: Int?
}

// MARK: - Profile
struct Profile: Decodable {
    let id: Int
    let firstName, lastName: String?
    let isClosed, canAccessClosed: Bool?
    let sex: Int
    let screenName: String?
    let photo50, photo100: String?
    let online: Int?
    let onlineInfo: POnlineInfo?
    let deactivated: String?
    
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
        case deactivated
    }
}

struct GroupPhotoNews: Decodable {
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
// MARK: - OnlineInfo
struct POnlineInfo: Decodable {
    let visible: Bool
    let lastSeen, appID: Int?
    let isMobile: Bool?
    
    enum CodingKeys: String, CodingKey {
        case visible
        case lastSeen = "last_seen"
        case appID = "app_id"
        case isMobile = "is_mobile"
    }
}
