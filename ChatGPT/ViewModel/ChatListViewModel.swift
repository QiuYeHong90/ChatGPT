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
    
    
    func sendMsg(msg: String) {
        let msgModel = MessageBodyModel.init()
        msgModel.content = msg
        var orignList = self.dataArray.value
        orignList.append(msgModel)
        self.dataArray.accept(orignList)
        let messages = orignList
        NetWork.sendMsg(messages: messages).request(modelType: ChatCompletion.self) { result in
            switch result {
            
            case .success(let value):
                let list = value?.choices ?? []
                for item in list {
                    let msgB = item.mapTo()
                    orignList.append(msgB)
                }
                self.dataArray.accept(orignList)
                print("dataArray === \(self.dataArray)")
                break
            case .failure(let error):
                break
            }
        }
        
    }
    
    
}
