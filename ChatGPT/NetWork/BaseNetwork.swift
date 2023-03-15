//
//  BaseNetwork.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/14.
//

import Moya
import Foundation

protocol BaseNetwork: TargetType {
    
}
extension BaseNetwork {
    var baseURL: URL {
        return URL.init(string: AppConfig.default.hostAddr)!
    }
    
    var method: Moya.Method {
        return .post
    }
    
    var sampleData: Data {
        Data.init()
    }
    
    var headers: [String : String]? {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(AppConfig.default.apiKey)"
        ]
    }
}
