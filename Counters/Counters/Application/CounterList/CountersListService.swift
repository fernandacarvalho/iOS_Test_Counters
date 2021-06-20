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
        self.getDataFromServer(url: url) { [unowned self] response in
            switch response {
            case .success(let data):
                do {
                    let list = try JSONDecoder().decode([Counter].self, from: data as! Data)
                    completionHandler(.success(list))
                } catch {
                    print(error.localizedDescription)
                    let baseResponse = self.getBaseResponseError(title: "Error", message: error.localizedDescription)
                    completionHandler(.failure(baseResponse))
                }
            case .failure(let baseResponse):
                completionHandler(.failure(baseResponse))
            }
            
        }
    }
}
