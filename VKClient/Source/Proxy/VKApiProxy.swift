//
//  VKApiProxy.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 25.03.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

import Foundation

class VKApiProxy: VKApiInterface {
    
    let service: VKApi
    init(service: VKApi) {
        self.service = service
    }
    
    func getSearchedGroup(for keyword: String, completion: @escaping ([Groups]) -> Void) {
        self.service.getSearchedGroup(for: keyword, completion: completion)
        print("called func getSearchedGroup with keyword = \(keyword)")
    }
}
