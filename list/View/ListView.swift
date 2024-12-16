//
//  ContentView.swift
//  list
//
//  Created by student on 16.12.2024.
//

import SwiftUI
import CoreData

struct ListView: View {
    //@Environment(\.managedObjectContext) private var viewContext

//    @FetchRequest(
//        sortDescriptors: [NSSortDescriptor(keyPath: \Item.timestamp, ascending: true)],
//        animation: .default)
    //private var items: FetchedResults<Item>
    
    @Environment(NetworkMonitor.self) private var networkMonitor
    @ObservedObject var listController: ListController

    var body: some View {
        NavigationView {
            List {
                if listController.hasConnection {
                    ForEach(listController.items) { item in
                        NavigationLink {
                            ItemView(id: item.getId(), listController: listController)
                        }
                    label: {
                        Text(item.name?.capitalized ?? "")
                    }
                    }
                } else {
                    Text("No internet")
                }
                //.onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItem {
                    Button(action: loadItems) {
                        Text("Load")
                    }
                }
            }
            Text("Select an item")
        }
    }
    
    private func loadItems() {
        Task {
            try await listController.updateItems()
        }
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(context: viewContext)
//            newItem.timestamp = Date()
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
//
//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            offsets.map { items[$0] }.forEach(viewContext.delete)
//
//            do {
//                try viewContext.save()
//            } catch {
//                let nsError = error as NSError
//                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
//            }
//        }
//    }
}

//private let itemFormatter: DateFormatter = {
//    let formatter = DateFormatter()
//    formatter.dateStyle = .short
//    formatter.timeStyle = .medium
//    return formatter
//}()

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
