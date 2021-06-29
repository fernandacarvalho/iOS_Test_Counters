//
//  CreateCounterService.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 28/06/21.
//

import Foundation


class CreateCounterService: CountersMainService {
    
    func createCounter(counterName: String, completionHandler: @escaping (RequestResultType<[Counter]>) -> Void) {
        let url = UtilUrlFactory.CreateCounter.counterUrl()
        let param: [String:String] = [
            "title": counterName
        ]
        self.postToServer(url: url, parameters: param) { response in
            switch response {
            case .success(let data):
                do {
                    let list = try JSONDecoder().decode([Counter].self, from: data as! Data)
                    completionHandler(.success(list))
                } catch {
                    let baseResponse = BaseResponse(
                        title: NSLocalizedString("COULDNT_CREATE_COUNTER", comment: ""),
                        message: error.localizedDescription)
                    completionHandler(.failure(baseResponse))
                }
            case .failure(let baseResponse):
                baseResponse.title = NSLocalizedString("COULDNT_CREATE_COUNTER", comment: "")
                completionHandler(.failure(baseResponse))
            }
        }
    }
}
