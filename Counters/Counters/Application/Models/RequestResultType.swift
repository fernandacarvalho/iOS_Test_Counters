//
//  RequestResultType.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 20/06/21.
//

import Foundation

public enum RequestResultType<T> {
    case success(T)
    case failure(BaseResponse)
}
