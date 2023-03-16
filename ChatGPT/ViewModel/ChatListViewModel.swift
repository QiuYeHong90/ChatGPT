//
//  ChatListViewModel.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/16.
//

import Moya
import RxRelay
import UIKit

class ChatListViewModel: NSObject {
    var dataArray: BehaviorRelay<[MessageBodyModel]>  = .init(value: [])
    var provider = MoyaProvider<NetWork>()
    
    
    func sendMsg(msg: String) {
        let msgModel = MessageBodyModel.init()
        msgModel.content = msg
        var orignList = self.dataArray.value
        orignList.append(msgModel)
        self.dataArray.accept(orignList)
        let messages = orignList
        self.provider.request(.sendMsg(messages: messages)) { result in
            switch result {
            
            case .success(let value):
                let json = try? value.mapString()
                
                let model = ChatCompletion.init(respone: value)
                let list = model?.choices ?? []
                for item in list {
                    let msgB = item.mapTo()
                    orignList.append(msgB)
                }
                self.dataArray.accept(orignList)
                print("dataArray === \(self.dataArray)")
                print("json === \(json)")
                break
            case .failure(let error):
                break
            }
        }
    }
    
    
}
