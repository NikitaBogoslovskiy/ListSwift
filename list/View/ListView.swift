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
    
    @ObservedObject var listController: ListController
    @Environment(\.managedObjectContext) private var viewContext

    var body: some View {
        NavigationView {
            List {
                if listController.hasConnection {
                    ForEach(listController.items) { item in
                        NavigationLink {
                            ItemView(id: item.getId(), listController: listController)
                                .environment(\.managedObjectContext, viewContext)
                        }
                        label: {
                            Text(item.name?.capitalized ?? "")
                        }
                    }
                } else {
                    Text("No internet")
                }
            }
            .toolbar {
                if listController.pageNumber > 1 {
                    ToolbarItem {
                        Button(
                            action: {
                                listController.pageNumber -= 1
                                loadItems()
                            },
                            label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.left")
                                }
                            }
                        )
                    }
                }
                
                if listController.items.count == listController.pageLimit {
                    ToolbarItem {
                        Button(
                            action: {
                                listController.pageNumber += 1
                                loadItems()
                            },
                            label: {
                                HStack(spacing: 4) {
                                    Image(systemName: "arrow.right")
                                }
                            }
                        )
                    }
                }
            }
        }
        .task {
            loadItems()
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

//#Preview {
//    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//}
