//
//  FetchDataOperation.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 09.01.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

import UIKit
import Alamofire

class FetchDataOperation: AsyncOperation {
    
    override func cancel() {
        request.cancel()
        super.cancel()
    }
    
    private var request: DataRequest
    var data: Data?
    
    override func main() {
        request.responseData(queue: DispatchQueue.global()) { [weak self] response in
            self?.data = response.data
            self?.state = .finished
        }
    }
    
    init(request: DataRequest) {
        self.request = request
    }
}
