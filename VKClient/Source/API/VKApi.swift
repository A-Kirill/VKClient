//
//  VKApi.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 13.11.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import Alamofire
import RealmSwift

class VKApi {
//example link: https://api.vk.com/method/METHOD_NAME?PARAMETERS&access_token=ACCESS_TOKEN&v=V
    let urlApi = "https://api.vk.com/method/"
    
    //get friends
    func getFriends(completion: @escaping ([Friend]) -> Void ) {
        let method = "friends.get"
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "order": "name",
            "fields": "domain, photo_50",
            "access_token": Session.instance.token,
            "v": "5.102"
        ]
        
        //  fetchRequest(url: urlApi+method, params: parameters, completionHandler: completion)
        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value,
            let friend = try? JSONDecoder().decode(FriendResponseWrapped.self, from: data)
            else { return }
//                print(String(bytes: data, encoding: .utf8) ?? "")
            
            //save data in realm
            DatabaseRealm.shared.saveFriendData(friend.response.items)
            completion(friend.response.items)
        }
    }
    
    //get groups
    func getUserGroups(completion: @escaping ([Groups]) -> Void ) {
        let method = "groups.get"
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "extended": "1", //1-full information about groups, 0 - default(only IDs)
            "access_token": Session.instance.token,
            "v": "5.102"
        ]
        
        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let groups = try! JSONDecoder().decode(GroupResponseWrapped.self, from: data)
            //save data in Realm
            DatabaseRealm.shared.saveGroupsData(groups.response.items)
            
            completion(groups.response.items)
        }
    }
    
    //get user's Photo
    func getUserPhoto(for userId: String, completion: @escaping ([PhotoItem]) -> Void ) {
        let method = "photos.get"
        let parameters: Parameters = [
            "owner_id": userId,
            "album_id": "profile", // "wall", "saved", "profile"
            "photo_sizes": "0", // 1 - all available sizes photos, 0 - default
            "extended": "1", //additional params(likes,comments...)default 0
            "access_token": Session.instance.token,
            "v": "5.102",
            "count": "10"
        ]
        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value,
            let photos = try? JSONDecoder().decode(Photo.self, from: data)
            else { return }
//            print(String(bytes: data, encoding: .utf8) ?? "")
            completion(photos.response.items)
        }
    }
    
    //get Groups by keyword
    func getSearchedGroup(for keyword: String, completion: @escaping ([Groups]) -> Void ) {
        let method = "groups.search"
        let parameters: Parameters = [
            "q": keyword,
            "type": "group",    // "page", "event"
            "sort": "0", // "2" sort for max amount followers
            "access_token": Session.instance.token,
            "v": "5.102"
        ]
        
        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value else { return }
            let groups = try! JSONDecoder().decode(GroupResponseWrapped.self, from: data)
            completion(groups.response.items)
        }
    }
    
    //get News
    func getUserNews(completion: @escaping ([NewsModel]) -> Void ) {
        let method = "newsfeed.get"
        let parameters: Parameters = [
            "filters": "post",
            "count": "20",
            "access_token": Session.instance.token,
            "v": "5.103"
        ]
        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseData { response in
            guard let data = response.value,
                let news = try? JSONDecoder().decode(NewsResponseWrapped.self, from: data)
                else { return }
                print(String(bytes: data, encoding: .utf8) ?? "")
            completion(news.response.items)
        }
    }
    
    //save data in Realm
//    func saveFriendData(_ items: [Friend]) {
//        do {
//            // get access to storage
//            let realm = try Realm()
//            // start change storage
//            realm.beginWrite()
//            // put all objects to storage
//            realm.add(items)
//            // finish all changes
//            try realm.commitWrite()
//        } catch {
//            // if error - print to console
//            print(error)
//        }
//    }
    
//    func saveGroupsData(_ items: [Groups]) {
//        do {
//            let realm = try Realm()
//            realm.beginWrite()
//            realm.add(items)
//            try realm.commitWrite()
//        } catch {
//            print(error)
//        }
//    }
    
    // Generic
    //    func fetchRequest<T: Decodable>(url: String, params: [String: Any], completionHandler: @escaping (T) -> ()) {
    //        Alamofire.request(url, method: .post, parameters: params).responseData { (data) in
    //            do {
    //                let result = try JSONDecoder().decode(T.self, from: data.data!)
    //                completionHandler(result)
    //            } catch {
    //                print("error parsing JSON")
    //            }
    //        }
    //    }
    
    //    func getFriends() {
    //        let method = "friends.get"
    //        let parameters: Parameters = [
    //            "user_id": Session.instance.userId,
    //            "order": "name",
    //            "fields": "domain",
    //            "access_token": Session.instance.token,
    //            "v": "5.102"
    //        ]
    //
    //        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseJSON { response in
    //            print("__________________ Friends List __________________")
    //            print(response.value ?? "")
    //        }
    //    }
    //
    //    func getUserGroups() {
    //        let method = "groups.get"
    //        let parameters: Parameters = [
    //            "user_id": Session.instance.userId,
    //            "extended": "0", //1-full information about groups, 0 - default(only IDs)
    //            "access_token": Session.instance.token,
    //            "v": "5.102"
    //        ]
    //
    //        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseJSON { response in
    //            print("__________________ User Groups __________________ ")
    //            print(response.value ?? "")
    //        }
    //    }
    //
    //    func getUserPhoto() {
    //        let method = "photos.get"
    //        let parameters: Parameters = [
    //            "owner_id": Session.instance.userId,
    //            "album_id": "profile", // "wall", "saved"
    //            "extended": "1", //if its group's photos should add "-1"
    //            "access_token": Session.instance.token,
    //            "v": "5.102"
    //        ]
    //
    //        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseJSON { response in
    //            print("__________________ User Photos __________________")
    //            print(response.value ?? "")
    //        }
    //    }
    //
    //    func getSearchedGroup(for keyword: String) {
    //        let method = "groups.search"
    //        let parameters: Parameters = [
    //            "q": keyword,
    //            "type": "group",    // "page", "event"
    //            "sort": "0", // "2" sort for max amount followers
    //            "access_token": Session.instance.token,
    //            "v": "5.102"
    //        ]
    //
    //        Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseJSON { response in
    //            print("__________________ Searched Groups __________________")
    //            print(response.value ?? "" )
    //        }
    //    }
}