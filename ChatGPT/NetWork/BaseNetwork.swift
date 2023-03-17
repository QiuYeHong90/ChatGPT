//
//  BaseNetwork.swift
//  ChatGPT
//
//  Created by Ray on 2023/3/14.
//

import ObjectMapper
import Moya
import Foundation

protocol BaseNetwork: TargetType {
    static var provider: MoyaProvider<Self> {get set}
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
    
    
    @discardableResult
    func request(callbackQueue: DispatchQueue? = .none,
                      progress: ProgressBlock? = .none,
                      completion: @escaping Completion) -> Cancellable {
       return Self.provider.request(self,callbackQueue: callbackQueue, progress: progress,completion: completion)
    }
    
    @discardableResult
    func request<T: Mappable>(modelType: T.Type,callbackQueue: DispatchQueue? = .none,
                      progress: ProgressBlock? = .none,
                      completion: @escaping (_ result: Result<T?, MoyaError>) -> Void) -> Cancellable {
        return Self.provider.request(self,callbackQueue: callbackQueue, progress: progress) { result in
            switch result {
            case .success(let value):
                let json = try? value.mapString()
                print("json === \(String(describing: json))")
                let model = modelType.init(respone: value)
                completion(.success(model))
                break
            case .failure(let error):
                completion(.failure(error))
                break
            }
        }
    }
    
}

extension ObjectMapper.Mappable {
    init?(respone:Moya.Response, context: MapContext? = nil) {
        guard let json = try? respone.mapJSON() as? [String: Any] else {
            return nil
        }
        if let obj: Self = Mapper(context: context).map(JSON: json) {
            self = obj
        } else {
            return nil
        }
    }
}
