//
//  ListItem.swift
//  list
//
//  Created by student on 16.12.2024.
//

import Foundation

class ListItem: Codable, Identifiable {
    var name: String?
    var url: String?
    
    func getId() -> Int {
        if url != nil {
            let urlComponents = url!.split(separator: "/")
            if urlComponents.count > 0 {
                return Int(urlComponents.last!) ?? 0
            }
        }
        return 0
    }
}

struct ListItemsJSONAnswer: Codable {
    let count: Int?
    let next: String?
    let previous: String?
    let results: [ListItem]?
}
