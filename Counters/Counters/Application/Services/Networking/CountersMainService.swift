//
//  CountersMainService.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 20/06/21.
//

import Foundation

class CountersMainService: NSObject {
    
    func getDataFromServer(url: String,
                       completionHandler: @escaping (RequestResultType<Any>) -> Void) {
        
        guard let requestUrl = URL(string: url) else {return}
        let service = Networking()
        
        service.dataRequest(requestUrl, httpMethod: "GET", parameters: nil) { response, error in
            DispatchQueue.main.async {
                if error != nil {
                    let baseResponse = self.getBaseResponseError(title: "Error", message: error!.localizedDescription)
                    completionHandler(.failure(baseResponse))
                    return
                }
                guard let data = response as? Data else {
                    let baseResponse = self.getBaseResponseError(title: "Error", message: error?.localizedDescription ?? "Please, try again.")
                    completionHandler(.failure(baseResponse))
                    return
                }
                completionHandler(.success(data))
            }
        }.resume()
    }
    
    func postToServer(url: String,
                       parameters: [String:String],
                       completionHandler: @escaping (RequestResultType<Any>) -> Void) {
        
        guard let requestUrl = URL(string: url) else {return}
        let service = Networking()
        service.dataRequest(requestUrl, httpMethod: "POST", parameters: parameters) { [unowned self] response, error in
            DispatchQueue.main.async {
                if error != nil {
                    let baseResponse = self.getBaseResponseError(title: "Error", message: error!.localizedDescription)
                    completionHandler(.failure(baseResponse))
                    return
                }
                
                guard let data = response as? Data else {
                    let baseResponse = self.getBaseResponseError(title: "Error", message: error?.localizedDescription ?? "Please, try again.")
                    completionHandler(.failure(baseResponse))
                    return
                }
                completionHandler(.success(data))
            }
        }.resume()
    }
    
    func getBaseResponseError(title: String, message: String) -> BaseResponse {
        return BaseResponse(title: NSLocalizedString("ERROR", comment: ""), message: message)
    }
}
