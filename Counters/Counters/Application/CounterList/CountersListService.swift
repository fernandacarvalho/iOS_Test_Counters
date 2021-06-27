//
//  CountersListService.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 20/06/21.
//

import Foundation

class CountersListService: CountersMainService {
    
    func getCounters(completionHandler: @escaping (RequestResultType<[Counter]>) -> Void) {
        let url = UtilUrlFactory.CountersList.countersUrl()
        self.getDataFromServer(url: url) { response in
            switch response {
            case .success(let data):
                do {
                    let list = try JSONDecoder().decode([Counter].self, from: data as! Data)
                    completionHandler(.success(list))
                } catch {
                    let baseResponse = BaseResponse(
                        title: NSLocalizedString("COULDNT_LOAD_COUNTERS", comment: ""),
                        message: error.localizedDescription)
                    completionHandler(.failure(baseResponse))
                }
            case .failure(let baseResponse):
                completionHandler(.failure(baseResponse))
            }
        }
    }
    
    func increaseCounter(counterId: String, completionHandler: @escaping (RequestResultType<[Counter]>) -> Void) {
        let url = UtilUrlFactory.CountersList.increaseCounterUrl()
        let param: [String:String] = [
            "id": counterId
        ]
        self.postToServer(url: url, parameters: param) { response in
            switch response {
            case .success(let data):
                do {
                    let list = try JSONDecoder().decode([Counter].self, from: data as! Data)
                    completionHandler(.success(list))
                } catch {
                    let baseResponse = BaseResponse(
                        title: NSLocalizedString("COULDNT_UPDATE_COUNTER", comment: ""),
                        message: error.localizedDescription)
                    completionHandler(.failure(baseResponse))
                }
            case .failure(let baseResponse):
                completionHandler(.failure(baseResponse))
            }
        }
    }
    
    func decreaseCounter(counterId: String, completionHandler: @escaping (RequestResultType<[Counter]>) -> Void) {
        let url = UtilUrlFactory.CountersList.decreaseCounterUrl()
        let param: [String:String] = [
            "id": counterId
        ]
        self.postToServer(url: url, parameters: param) { response in
            switch response {
            case .success(let data):
                do {
                    let list = try JSONDecoder().decode([Counter].self, from: data as! Data)
                    completionHandler(.success(list))
                } catch {
                    let baseResponse = BaseResponse(
                        title: NSLocalizedString("COULDNT_UPDATE_COUNTER", comment: ""),
                        message: error.localizedDescription)
                    completionHandler(.failure(baseResponse))
                }
            case .failure(let baseResponse):
                completionHandler(.failure(baseResponse))
            }
        }
    }
}
