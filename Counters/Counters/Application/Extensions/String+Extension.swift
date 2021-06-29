//
//  String+Extension.swift
//  Counters
//
//  Created by Fernanda FC. Carvalho on 29/06/21.
//

import Foundation

public extension String {
    var withoutWhiteSpaces: String {
        return self.replacingOccurrences(of: "^\\s+|\\s+|\\s+$",
                                         with: "",
                                         options: .regularExpression)
    }
}
