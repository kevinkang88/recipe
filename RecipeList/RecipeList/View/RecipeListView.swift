//
//  RecipesListView.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import SwiftUI

struct RecipeListView: View {
    @StateObject private var viewModel = RecipeListViewModel(service: RecipeService())

    var body: some View {
        NavigationView {
            Group {
                if viewModel.isLoading {
                    ProgressView("Loading recipes...")
                } else if let errorMessage = viewModel.errorMessage {
                    Text(errorMessage).foregroundColor(.red)
                } else if viewModel.displayedRecipes.isEmpty {
                    Text("No recipes available.")
                } else {
                    List(viewModel.displayedRecipes) { recipe in
                        RecipeRow(recipe: recipe)
                            .onAppear {
                                if recipe == viewModel.displayedRecipes.last {
                                    viewModel.loadMoreRecipes()
                                }
                            }
                    }
                    .refreshable {
                        await viewModel.fetchRecipes()
                    }
                }
            }
            .navigationTitle("Recipes")
            .task {
                await viewModel.fetchRecipes()
            }
        }
    }
}
