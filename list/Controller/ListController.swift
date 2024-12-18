//
//  ListController.swift
//  list
//
//  Created by student on 16.12.2024.
//

import Foundation

class ListController: ObservableObject {
    static let shared = ListController()
    let apiEndpoint = "https://pokeapi.co/api/v2/pokemon"
    let pageLimit = 20
    var pageNumber = 1
    
    @Published var items = [ListItem]()
    @Published var hasConnection = true
    
    func updateItems() async throws {
        guard let url = URL(string: "\(apiEndpoint)?limit=\(pageLimit)&offset=\((pageNumber - 1) * pageLimit)") else { return }
        do {
            let configuration = URLSessionConfiguration.default
            configuration.urlCache = nil
            let (data, response) = try await URLSession(configuration: configuration).data(for: URLRequest(url: url))
            if let httpResponse = response as? HTTPURLResponse {
                await MainActor.run {
                    self.hasConnection = (httpResponse.statusCode == 200)
                }
            }
            let decodedData = try JSONDecoder().decode(ListItemsJSONAnswer.self, from: data)
            if (decodedData.results != nil) {
                await MainActor.run {
                    self.items.removeAll()
                    for item in decodedData.results! {
                        self.items.append(item)
                    }
                }
            }
        } catch {
            await MainActor.run {
                self.hasConnection = false
            }
        }
    }
    
    func getItem(id: Int) async throws -> ItemDetails {
        guard let url = URL(string: "\(apiEndpoint)/\(id)") else { return ItemDetails() }
        let (data, _) = try await URLSession.shared.data(for: URLRequest(url: url))
        let decodedData = try JSONDecoder().decode(ItemDetails.self, from: data)
        decodedData.itemId = id
        return decodedData
    }
}
