//
//  ItemDetails.swift
//  list
//
//  Created by student on 16.12.2024.
//

import Foundation
import CoreData

class ItemDetails: Codable, Identifiable {
    var itemId: Int?
    var name: String?
    var height: Int?
    var weight: Int?
    var abilities: [AbilityWrapper]?
    var stats: [StatWrapper]?
    var types: [TypeWrapper]?
    var sprites: Sprites?
    
    static func fromNS(entity: ItemDetailsEntity) -> ItemDetails {
        var result = ItemDetails()
        result.itemId = entity.entityId != nil ? Int(entity.entityId!) : nil
        result.name = entity.name
        result.height = entity.height != nil ? Int(entity.height!) : nil
        result.weight = entity.weight != nil ? Int(entity.weight!) : nil
        
        if entity.abilities != nil {
            result.abilities = entity.abilities!.split(separator: ";").map { abilityString in
                let abilityWrapper = AbilityWrapper()
                let abilityContent = AbilityContent()
                abilityContent.name = String(abilityString)
                abilityWrapper.ability = abilityContent
                return abilityWrapper
            }
        }
        
        if entity.types != nil {
            result.types = entity.types!.split(separator: ";").map { typeString in
                let typeWrapper = TypeWrapper()
                let typeContent = TypeContent()
                typeContent.name = String(typeString)
                typeWrapper.type = typeContent
                return typeWrapper
            }
        }
        
        if entity.stats != nil {
            result.stats = entity.stats!.split(separator: ";").map { statString in
                let statWrapper = StatWrapper()
                let statContent = StatContent()
                let statData = String(statString).split(separator: ":")
                if statData.count == 2 {
                    statContent.name = String(statData.first!)
                    statWrapper.stat = statContent
                    statWrapper.base_stat = Int(statData.last!)
                }
                return statWrapper
            }.filter { stat in stat.base_stat != nil }
        }
        
        if entity.sprites != nil {
            let sprites = Sprites()
            sprites.front_default = entity.sprites!
            result.sprites = sprites
        }
        
        return result
    }
    
    func toNS(result: inout ItemDetailsEntity) {
        result.entityId = itemId != nil ? String(itemId!) : nil
        result.name = name
        result.height = height != nil ? String(height!) : nil
        result.weight = weight != nil ? String(weight!) : nil
        
        if abilities != nil && abilities!.count > 0 {
            var abilitiesString = ""
            for ability in abilities! {
                if ability.ability != nil {
                    let name = ability.ability?.name
                    if name != nil && !name!.isEmpty {
                        abilitiesString += name! + ";"
                    }
                }
            }
            result.abilities = String(abilitiesString.prefix(abilitiesString.count - 1))
        }
        
        if types != nil && types!.count > 0 {
            var typesString = ""
            for type in types! {
                if type.type != nil {
                    let name = type.type?.name
                    if name != nil && !name!.isEmpty {
                        typesString += name! + ";"
                    }
                }
            }
            result.types = String(typesString.prefix(typesString.count - 1))
        }
        
        if stats != nil && stats!.count > 0 {
            var statsString = ""
            for stat in stats! {
                if stat.base_stat != nil && stat.stat != nil {
                    let name = stat.stat?.name
                    if name != nil && !name!.isEmpty {
                        statsString += name! + ":" + String(stat.base_stat!) + ";"
                    }
                }
            }
            result.stats = String(statsString.prefix(statsString.count - 1))
        }
        
        if sprites != nil && sprites!.front_default != nil {
            result.sprites = sprites!.front_default!
        }
    }
}

class ItemDetailsNS: NSManagedObject {
    
//    func fromNS() -> ItemDetails {
//        var result = ItemDetails()
//        result.name = name
//        result.height = Int(height)
//        result.weight = Int(weight)
//        result.abilities = []
//        
//        for item in abilities! {
//            let ability = item as? AbilityWrapperNS
//        }
//        result.abilities = abilities.map { item in
//            let ability = item as AbilityWrapperNS
//            var abilityWrapper = AbilityWrapper()
//            var abilityContent = AbilityContent()
//            abilityContent.name = ability.ability.name
//            abilityWrapper.ability = abilityContent
//            return abilityWrapper
//        }
//        
//        result.stats = stats.map { stat in
//            var statWrapper = StatWrapper()
//            var statContent = StatContent()
//            statContent.name = stat.stat.name
//            statWrapper.stat = statContent
//            statWrapper.base_stat = stat.base_stat
//            return statWrapper
//        }
//        
//        result.types = types.map { type in
//            var typeWrapper = TypeWrapper()
//            var typeContent = TypeContent()
//            typeContent.name = type.type.name
//            typeWrapper.type = typeContent
//            return typeWrapper
//        }
//
//        var sprites = Sprites()
//        sprites.front_default = self.sprites.front_default
//        result.sprites = sprites
//        
//        return result
//    }
}

class AbilityWrapper: Codable, Identifiable {
    var ability: AbilityContent?
}

class AbilityWrapperNS: NSManagedObject {
    //@NSManaged var ability: AbilityContentNS
}

class AbilityContent: Codable {
    var name: String?
}

class AbilityContentNS: NSManagedObject {
    //@NSManaged var name: String
}

class StatWrapper: Codable, Identifiable {
    var base_stat: Int?
    var stat: StatContent?
}

class StatWrapperNS: NSManagedObject {
    //@NSManaged var base_stat: Int
    //@NSManaged var stat: StatContentNS
}

class StatContent: Codable {
    var name: String?
}

class StatContentNS: NSManagedObject {
    //@NSManaged var name: String
}

class TypeWrapper: Codable, Identifiable {
    var type: TypeContent?
}

class TypeWrapperNS: NSManagedObject {
    //@NSManaged var type: TypeContentNS
}

class TypeContent: Codable {
    var name: String?
}

class TypeContentNS: NSManagedObject {
    //@NSManaged var name: String?
}

class Sprites: Codable {
    var front_default: String?
}

class SpritesNS: NSManagedObject {
    //@NSManaged var front_default: String
}
