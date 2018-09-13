//
//  NetworkClient.swift
//  TestiOSCurrency
//
//  Created by Dmitry Grebenschikov on 12/09/2018.
//  Copyright © 2018 dd-team. All rights reserved.
//

import RxSwift
import RxAlamofire
import ObjectMapper
import Alamofire

enum AppErrors: Error {
    case parseError
}

public class NetworkClient<T: Mappable> {
    
    public init() {
        URLCache.shared.diskCapacity = 0
    }
    
    public func get(from url: URL,
                    headers: [String: String]? = nil,
                    parameters: [String: Any]?) -> Observable<T> {
        return request(method: .get, url: url, headers: headers, parameters: parameters)
    }
    
    
    private func request(method: HTTPMethod,
                         url: URL,
                         headers: [String: String]?,
                         parameters: [String: Any]?) -> Observable<T> {
        return Observable.deferred({
            let encoding: ParameterEncoding = method == .get ? URLEncoding.default : JSONEncoding.default
            return SessionManager.default.rx.responseJSON(method, url, parameters: parameters, encoding: encoding, headers: headers)
                .map({ (response, json) -> T in
                    guard let object = Mapper<T>().map(JSONObject: json) else {
                        throw AppErrors.parseError
                    }
                    return object
                })
        })
        
    }
}
