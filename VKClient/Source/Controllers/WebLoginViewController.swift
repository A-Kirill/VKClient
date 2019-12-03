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
            URLQueryItem(name: "scope", value: "wall,friends,groups,offline"),
//            URLQueryItem(name: "scope", value: "262150"),
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
        
        //safe token and id in Realm
        let realm = try! Realm()
        try! realm.write {
            if let token = tokenVK,
                let userId = Int(userIdVK ?? "") {
                if realm.objects(UserSettings.self).first == nil {
                    let userSettings = UserSettings()
                    userSettings.token = token
                    userSettings.id = userId
                    realm.add(userSettings)
                } else {
                    let user = realm.objects(UserSettings.self).first!
                    user.token = token
                    user.id = userId
                }
            }
        }
        
        performSegue(withIdentifier: "fromWebLogin", sender: tokenVK)
        
        decisionHandler(.cancel)
    }
}

