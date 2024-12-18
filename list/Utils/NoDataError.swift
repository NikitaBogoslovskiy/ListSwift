//
//  NoDataError.swift
//  list
//
//  Created by student on 17.12.2024.
//

import Foundation

struct NoDataError: LocalizedError {
    let description: String
    
    init (_ description: String) {
        self.description = description
    }
    
    var errorDescription: String? {
        description
    }
}
