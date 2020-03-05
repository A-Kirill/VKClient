//
//  FriendsAdapter.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 03.03.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

import Foundation
import RealmSwift

final class FriendsAdapter {
    
    private let vkapi = VKApi()
    private var realmNotificationTokens: NotificationToken?
    var realmFriends: Results<Friend>!
    
    func getFriendsAdapt(completion: @escaping ([FriendStruct]) -> Void ) {
        var friendStruct: [FriendStruct] = []
        vkapi.getFriends() { realmFriends in
            for realmFriends in realmFriends {
                friendStruct.append(self.friendsStr(from: realmFriends))
            }
        }
        realmFriends = DatabaseRealm.shared.getRealmFriends()
    }
    
    private func friendsStr(from rlmFriend: Friend) -> FriendStruct {
        return FriendStruct(id: rlmFriend.id, firstName: rlmFriend.firstName, lastName: rlmFriend.lastName, photo: rlmFriend.photo)
    }
}
