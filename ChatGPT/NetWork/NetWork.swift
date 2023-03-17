//
//  NetWork.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/14.
//

import Moya
import Foundation
enum NetWork {
    static var provider = MoyaProvider<Self>()
    
    case sendMsg(messages: [MessageBodyModel])
}


extension NetWork: BaseNetwork {
    var path: String {
        switch self {
        case .sendMsg(_):
            return "/v1/chat/completions"
        }
    }
    var task: Moya.Task {
        var params: [String: Any] = [:]
        switch self {
        case .sendMsg(let messages):
            params["model"] = "gpt-3.5-turbo"
            params["messages"] = messages.toJSON()
        }
        print("params = \(params)")
        return Moya.Task.requestParameters(parameters: params, encoding: JSONEncoding.default)
    }
}
