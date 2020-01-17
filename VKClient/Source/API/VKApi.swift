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
        
        // transfer request to global queue:
        DispatchQueue.global().async {
            Alamofire.request(self.urlApi+method, method: .get, parameters: parameters).responseData { response in
                DispatchQueue.global().async {
                    guard let data = response.value,
                        let friend = try? JSONDecoder().decode(FriendResponseWrapped.self, from: data)
                        else { return }
                    //                print(String(bytes: data, encoding: .utf8) ?? "")
                    //save data in realm
                    DatabaseRealm.shared.saveFriendData(friend.response.items)
                    
                    completion(friend.response.items)
                }
            }
        }
    }
    
    //get friends with PromiseKit
//    func getUserPromiseKit() -> Promise<[Friend]> {
//        let method = "friends.get"
//        let parameters: Parameters = [
//            "user_id": Session.instance.userId,
//            "order": "name",
//            "fields": "domain, photo_50",
//            "access_token": Session.instance.token,
//            "v": "5.102"
//        ]
//        
//        let promise = Promise<[Friend]> { resolver in
//            Alamofire.request(self.urlApi+method, method: .get, parameters: parameters).responseData { response in
//                switch response.result {
//                case .success(let value):
//                    guard let data = response.value else { return }
//                    do {
//                        let friend = try JSONDecoder().decode(FriendResponseWrapped.self, from: data)
//                        resolver.fulfill(friend.response.items)
//                    } catch let decodeError {
//                        print("Decode error", decodeError)
//                    }
//                case .failure(let error):
//                    resolver.reject(error)
//                }
//            }
//        }
//        
//        return promise
//    }
    
    
    //get groups
    func getUserGroups(completion: @escaping ([Groups]) -> Void ) {
        let method = "groups.get"
        let parameters: Parameters = [
            "user_id": Session.instance.userId,
            "extended": "1", //1-full information about groups, 0 - default(only IDs)
            "access_token": Session.instance.token,
            "v": "5.102"
        ]
        
        DispatchQueue.global().async {
            Alamofire.request(self.urlApi+method, method: .get, parameters: parameters).responseData { response in
                DispatchQueue.global().async {
                    guard let data = response.value else { return }
                    let groups = try! JSONDecoder().decode(GroupResponseWrapped.self, from: data)
                    //save data in Realm
                    DatabaseRealm.shared.saveGroupsData(groups.response.items)
                    completion(groups.response.items)
                }
            }
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
        
        DispatchQueue.global().async {
            Alamofire.request(self.urlApi+method, method: .get, parameters: parameters).responseData { response in
                DispatchQueue.global().async {
                    guard let data = response.value,
                        let photos = try? JSONDecoder().decode(Photo.self, from: data)
                        else { return }
                    //            print(String(bytes: data, encoding: .utf8) ?? "")
                    DispatchQueue.main.async {
                        completion(photos.response.items)
                    }
                }
                
            }
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
        
        DispatchQueue.global().async {
            Alamofire.request(self.urlApi+method, method: .get, parameters: parameters).responseData { response in
                DispatchQueue.global().async {
                    guard let data = response.value else { return }
                    let groups = try! JSONDecoder().decode(GroupResponseWrapped.self, from: data)
                    DispatchQueue.main.async {
                        completion(groups.response.items)
                    }
                }
            }
        }
    }
    
    //get News:
    func getUserNews(completion: @escaping (NewsResponse) -> Void ) {
        let method = "newsfeed.get"
        let parameters: Parameters = [
            "filters": "post",
            "count": "5",
            "access_token": Session.instance.token,
            "v": "5.103"
        ]
        
        DispatchQueue.global().async {
            Alamofire.request(self.urlApi+method, method: .get, parameters: parameters).responseData { response in
                DispatchQueue.global().async {
                    guard let data = response.value,
                        let news = try? JSONDecoder().decode(NewsResponseWrapped.self, from: data) else {
                            let result = String(bytes: response.value!, encoding: .utf8)
                            print(result ?? "error")
                            return
                    }
                    DispatchQueue.main.async {
                        completion(news.response)
                    }
                }
            }
        }
    }
    
    func getPhotoNews(completion: @escaping (PhotoNewsResponse) -> Void ) {
        let method = "newsfeed.get"
        let parameters: Parameters = [
            "filters": "photo",
            "source_ids": "friends",
            "count": "5",
            "access_token": Session.instance.token,
            "v": "5.103"
        ]
        
        DispatchQueue.global().async {
            Alamofire.request(self.urlApi+method, method: .get, parameters: parameters).responseData { response in
                guard let data = response.value,
                    let photoNews = try? JSONDecoder().decode(PhotoNewsWrapped.self, from: data) else {
                        let result = String(bytes: response.value!, encoding: .utf8)
                        print(result ?? "error")
                        return
                }
                completion(photoNews.response)
            }
        }
    }
    
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
}
