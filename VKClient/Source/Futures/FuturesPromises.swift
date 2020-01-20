//
//  FuturesPromises.swift
//  VKClient
//
//  Created by Кирилл Анисимов on 17.01.2020.
//  Copyright © 2020 Кирилл Анисимов. All rights reserved.
//

import Foundation

//class Future<T> {
//    
//    fileprivate var result: Result<T, Error>? {
//        didSet {
//            guard let result = result else { return }
//            callbacks.forEach { $0(result) }
//        }
//    }
//    
//    private var callbacks = [(Result<T, Error>) -> Void]()
//    
//    func add(callback: @escaping (Result<T, Error>) -> Void) {
//        callbacks.append(callback)
//        
//        result.map(callback)
//    }
//}
//
//
//class Promise<T>: Future<T> {
//    init(value: T? = nil) {
//        super.init()
//        //if result is already available, then we can put it to success case
//        result = value.map(Result.success)
//    }
//    
//    func fulfill(with value: T) {
//        result = .success(value)
//    }
//    
//    func reject(with error: Error) {
//        result = .failure(error)
//    }
//}
//
////for chain of async requests
//extension Future {
//    func map<NewType>(with closure: @escaping (T) throws -> NewType) -> Future<NewType> {
//        let promise = Promise<NewType>()
//        
//        add(callback: { result in
//            switch result {
//            case .success(let value):
//                do {
//                    let mappedValue = try closure(value)
//                    promise.fulfill(with: mappedValue)
//                } catch {
//                    promise.reject(with: error)
//                }
//            case .failure(let error):
//                promise.reject(with: error)
//            }
//        })
//        
//        return promise
//    }
//}
//
//extension Future {
//    func flatMap<NewType>(with closure: @escaping (T) throws -> Future<NewType>) -> Future<NewType> {
//        
//        let promise = Promise<NewType>()
//        
//        add(callback: { result in
//            switch result {
//            case .success(let value):
//                do {
//                    let chainedPromise = try closure(value)
//                    chainedPromise.add(callback: { result in
//                        switch result {
//                        case .success(let value):
//                            promise.fulfill(with: value)
//                        case .failure(let error):
//                            promise.reject(with: error)
//                        }
//                    })
//                } catch {
//                    promise.reject(with: error)
//                }
//            case .failure(let error):
//                promise.reject(with: error)
//            }
//        })
//        
//        return promise
//    }
//}
