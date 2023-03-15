//
//  ApiConfig.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/14.
//

import Foundation
struct AppConfig  {
    var hostAddr: String
    var apiKey: String
    
    static let `default`: AppConfig = {
        
        let model = AppConfig.init(hostAddr: "https://api.openai.com", apiKey: "apiKey")
        
        return model
    }()
    
    
    
}
