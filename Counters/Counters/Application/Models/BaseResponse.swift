//
//  BaseResponse.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 20/06/21.
//

import Foundation

public class BaseResponse: NSObject {
    var title: String = ""
    var message: String = ""
    
    init(title: String, message: String){
        self.title = title
        self.message = message
    }
}
