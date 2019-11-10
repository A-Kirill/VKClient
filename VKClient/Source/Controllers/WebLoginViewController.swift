//
//  WebLoginViewController.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 26.10.2019.
//  Copyright © 2019 Кирилл Анисимов. All rights reserved.
//

import UIKit
import Alamofire
import WebKit
import RealmSwift

class WebLoginViewController: UIViewController {

    @IBOutlet weak var webView: WKWebView!
    
    override func viewDidLoad() {
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = "oauth.vk.com"
        urlComponents.path = "/authorize"
        urlComponents.queryItems = [
            URLQueryItem(name: "client_id", value: "7184831"),
            URLQueryItem(name: "display", value: "mobile"),
            URLQueryItem(name: "redirect_uri", value: "https://oauth.vk.com/blank.html"),
            URLQueryItem(name: "scope", value: "262150"),
            URLQueryItem(name: "response_type", value: "token"),
            URLQueryItem(name: "v", value: "5.68")
        ]
        
        let request = URLRequest(url: urlComponents.url!)
        
        webView.load(request)
        
        webView.navigationDelegate = self
    }
}

extension WebLoginViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, decidePolicyFor navigationResponse: WKNavigationResponse, decisionHandler: @escaping (WKNavigationResponsePolicy) -> Void) {
        guard let url = navigationResponse.response.url,
            url.path == "/blank.html" else {
                decisionHandler(.allow)
                return
        }
        
        //token=sadfasas&userid=12312   разбитие строки на отдельные параметры
        let params = url.fragment?
            .components(separatedBy: "&")
            .map{ $0.components(separatedBy: "=") }
            .reduce([String: String](), {(result, params) in
                var dict = result
                let key = params[0]
                let value = params[1]
                dict[key] = value
                return dict
            })
        
        print(params!)
        let tokenVK = params?["access_token"]
        let userIdVK = params?["user_id"]
        
        //adding params to singletone
        Session.instance.token = tokenVK ?? ""
        Session.instance.userId = userIdVK ?? ""
        
//       vkApi.getFriends()
//        vkApi.getUserGroups()
//        vkApi.getUserPhoto()
//        vkApi.getSearchedGroup(for: "ios developers")
        
        performSegue(withIdentifier: "fromWebLogin", sender: tokenVK)
        
        decisionHandler(.cancel)
    }
}

    //example link: https://api.vk.com/method/METHOD_NAME?PARAMETERS&access_token=ACCESS_TOKEN&v=V

class VKApi {
    
    let urlApi = "https://api.vk.com/method/"
    
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
            guard let data = response.value else { return }
            let friend = try! JSONDecoder().decode(FriendResponseWrapped.self, from: data)
            //save data in realm
            self.saveFriendData(friend.response.items)
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
                self.saveGroupsData(groups.response.items)
                
                completion(groups.response.items)
            }
        }
  
    //get user's Photo
    func getUserPhoto(for userId: String, completion: @escaping ([PhotoItem]) -> Void ) {
            let method = "photos.get"
            let parameters: Parameters = [
                "owner_id": userId,
                "album_id": "wall", // "wall", "saved", "profile"
                "extended": "1", //if its group's photos should add "-1"
                "access_token": Session.instance.token,
                "v": "5.102",
                "count": "10"
            ]
    
            Alamofire.request(urlApi+method, method: .get, parameters: parameters).responseData { response in
                guard let data = response.value else { return }
                let photos = try! JSONDecoder().decode(PhotoResponse.self, from: data).items
                completion(photos)
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
    
    //save data in Realm
    func saveFriendData(_ items: [Friend]) {
        do {
            // get access to storage
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
        do {
            let realm = try Realm()
            realm.beginWrite()
            realm.add(items)
            try realm.commitWrite()
        } catch {
            print(error)
        }
    }

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

