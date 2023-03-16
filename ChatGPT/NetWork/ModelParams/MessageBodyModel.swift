//
//  MessageBodyModel.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/16.
//

import UIKit

import ObjectMapper

class MessageBodyModel: NSObject, Mappable {
    enum Role: String {
        case user
        case assistant
    }
    
    var role: Role = .user
    var content: String?
    override init() {
        super.init()
    }
    required init?(map: Map) {

    }

    func mapping(map: Map) {
        role <- map["role"]
        content <- map["content"]
    }
}



struct ChatCompletion: Mappable {
    var id: String?
    var object: String?
    var created: Int?
    var model: String?
    var usage: Usage?
    var choices: [Choice]?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        object <- map["object"]
        created <- map["created"]
        model <- map["model"]
        usage <- map["usage"]
        choices <- map["choices"]
    }
}

struct Usage: Mappable {
    var promptTokens: Int?
    var completionTokens: Int?
    var totalTokens: Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        promptTokens <- map["prompt_tokens"]
        completionTokens <- map["completion_tokens"]
        totalTokens <- map["total_tokens"]
    }
}

struct ChoiceTemplate: Mappable {
    var role: MessageBodyModel.Role = .assistant
    var content: String?
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        role <- map["role"]
        content <- map["content"]
    }
}

struct Choice: Mappable {
    var message: ChoiceTemplate?
    var finishReason: String?
    var index: Int?

    init?(map: Map) {}
    
    func mapTo() -> MessageBodyModel {
        let msgBody = MessageBodyModel.init()
        msgBody.role = self.message?.role ?? .assistant
        msgBody.content = self.message?.content
        return msgBody
    }
    mutating func mapping(map: Map) {
        message <- map["message"]
        finishReason <- map["finish_reason"]
        index <- map["index"]
    }
}
