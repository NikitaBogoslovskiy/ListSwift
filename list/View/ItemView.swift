//
//  ItemView.swift
//  list
//
//  Created by student on 16.12.2024.
//

import Foundation
import SwiftUI
import CoreData

struct ItemView: View {
    var id: Int
    @ObservedObject var listController: ListController
    @State var content: ItemDetails = ItemDetails()
    @State var hasConnection = true
    @Environment(\.managedObjectContext) private var viewContext
    
    var body: some View {
        ItemDetailsViewWrapper(content: content, hasConnection: hasConnection)
        .task {
            do {
                do {
                    let results = try viewContext.fetch(NSFetchRequest(entityName: "ItemDetailsData")) as [ItemDetailsEntity]
                    let stringId = String(self.id)
                    let result = results.filter { entity in entity.entityId == stringId }.first
                    if result == nil {
                        print("No offline data")
                        throw NoDataError("")
                    }
                    content = ItemDetails.fromNS(entity: result!)
                    print("Loaded offline data")
                } catch {
                    content = try await listController.getItem(id: id)
                    print("Loaded online data")
                    var newEntity = ItemDetailsEntity(context: viewContext)
                    content.toNS(result: &newEntity)
                    do {
                        try viewContext.save()
                    } catch {
                        let nsError = error as NSError
                        fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
                    }
                    hasConnection = true
                }
            } catch {
                hasConnection = false
                print("No internet")
            }
        }
    }
}

struct ItemDetailsViewWrapper: View {
    var content: ItemDetails
    var hasConnection: Bool
    
    var body: some View {
        if hasConnection {
            ItemDetailsView(content: content)
        } else {
            Text("No internet")
        }
    }
}

struct ItemDetailsView: View {
    var content: ItemDetails
    
    var body: some View {
        
        ScrollView {
            AsyncImage(url: URL(string: content.sprites?.front_default ?? ""))
            
            Text(content.name?.capitalized ?? "").font(.system(size: 34).weight(.heavy))
            
            if content.height != nil || content.weight != nil {
                VStack {
                    Text("Parameters").font(.system(size: 22).weight(.heavy))
                    
                    if content.height != nil {
                        HStack {
                            Text("Height").font(.system(size: 18))
                            Text(String(content.height!)).font(.system(size: 18).weight(.heavy))
                        }
                    }
                    
                    if content.weight != nil {
                        HStack {
                            Text("Weight").font(.system(size: 18))
                            Text(String(content.weight!)).font(.system(size: 18).weight(.heavy))
                        }
                    }
                }.padding()
            }
            
            if content.abilities != nil && content.abilities!.count > 0 {
                VStack {
                    Text("Abilities").font(.system(size: 22).weight(.heavy))
                    ForEach(content.abilities!) { ability in
                        Text(ability.ability!.name!.capitalized).font(.system(size: 18))
                    }
                }.padding()
            }
            
            if content.types != nil && content.types!.count > 0 {
                VStack {
                    Text("Types").font(.system(size: 22).weight(.heavy))
                    ForEach(content.types!) { type in
                        Text(type.type!.name!.capitalized).font(.system(size: 18))
                    }
                }.padding()
            }
            
            if content.stats != nil && content.stats!.count > 0 {
                VStack {
                    Text("Stats").font(.system(size: 22).weight(.heavy))
                    ForEach(content.stats!) { stat in
                        HStack {
                            Text(stat.stat!.name!.capitalized).font(.system(size: 18))
                            Text(String(stat.base_stat!)).font(.system(size: 18).weight(.heavy))
                        }
                        //Text(stat.stat!.name!.capitalized + " " + String(stat.base_stat!)).font(.system(size: 20))
                    }
                }.padding()
            }
        }
    }
}
