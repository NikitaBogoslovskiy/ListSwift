//
//  ItemDetails.swift
//  list
//
//  Created by student on 16.12.2024.
//

import Foundation

class ItemDetails: Codable, Identifiable {
    var id: Int?
    var name: String?
    var height: Int?
    var weight: Int?
    var abilities: [AbilityWrapper]?
    var stats: [StatWrapper]?
    var types: [TypeWrapper]?
    var sprites: Sprites?
}

class AbilityWrapper: Codable, Identifiable {
    var ability: AbilityContent?
}

class AbilityContent: Codable {
    var name: String?
}

class StatWrapper: Codable, Identifiable {
    var base_stat: Int?
    var stat: StatContent?
}

class StatContent: Codable {
    var name: String?
}

class TypeWrapper: Codable, Identifiable {
    var type: TypeContent?
}

class TypeContent: Codable {
    var name: String?
}

class Sprites: Codable {
    var front_default: String?
}
