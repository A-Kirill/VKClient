//
//  Database.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 17.11.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import RealmSwift

class DatabaseRealm {
    static let shared = DatabaseRealm()
    
    func saveFriendData(_ items: [Friend]) {
        do {
            let realm = try Realm()
            // start change storage
            realm.beginWrite()
            // put all objects to storage
            realm.add(items)
            // finish all changes
            try realm.commitWrite()
        } catch {
            // if error - print to console
            print(error)
        }
    }
    
    func saveGroupsData(_ items: [Groups]) {
        let realm = try! Realm()
        
        try? realm.write {
            realm.add(items, update: .modified)
        }
    }

    func getRealmFriends() -> Results<Friend> {
        let realm = try! Realm()
        
        return realm.objects(Friend.self)
    }
    
    func getRealmGroups() -> Results<Groups> {
        let realm = try! Realm()
        
        return realm.objects(Groups.self)
    }
//    func getRealmFriends() -> [Friend] {
//        let realm = try! Realm()
//
//        let friendsRealm = realm.objects(Friend.self)
//        return Array(friendsRealm)
//    }
    
//    func getRealmGroups() -> [Groups] {
//        let realm = try! Realm()
//
//        let groupsRealm = realm.objects(Groups.self)
//        return Array(groupsRealm)
//    }
    
    func clearRealm() {
        let realm = try! Realm()
        
        try! realm.write {
            realm.deleteAll()
        }
    }
}
