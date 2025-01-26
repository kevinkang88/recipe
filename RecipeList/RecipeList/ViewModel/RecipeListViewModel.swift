//
//  RecipeListViewModel.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import SwiftUI

@MainActor
class RecipeListViewModel: ObservableObject {
    @Published var displayedRecipes: [Recipe] = []
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    private let service: RecipeServiceProtocol
    private var allRecipes: [Recipe] = []
    private let pageSize = 15
    private var currentPage = 0

    init(service: RecipeServiceProtocol) {
        self.service = service
    }

    func fetchRecipes() async {
        isLoading = true
        currentPage = 0
        displayedRecipes.removeAll()
        do {
            allRecipes = try await service.fetchRecipes()
            errorMessage = nil
            loadMoreRecipes()
        } catch {
            errorMessage = "Failed to load recipes."
        }
        isLoading = false
    }

    func loadMoreRecipes() {
        let nextLimit = min((currentPage + 1) * pageSize, allRecipes.count)
        if nextLimit > displayedRecipes.count {
            displayedRecipes.append(contentsOf: allRecipes[displayedRecipes.count..<nextLimit])
            currentPage += 1
        }
    }
}
