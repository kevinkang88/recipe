//
//  RecipeService.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import Foundation

protocol RecipeServiceProtocol {
    func fetchRecipes() async throws -> [Recipe]
    // TODO: down the line refactor to own protocol since not directly related to recipes
    func fetchImage(from url: URL) async throws -> Data
}

final class RecipeService: RecipeServiceProtocol {
    func fetchImage(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)

        guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
            throw RecipeServiceError.invalidResponse
        }

        return data
    }
    
    private let recipiesListURL = "https://d3jbb8n5wk0qxi.cloudfront.net/recipes.json"

    func fetchRecipes() async throws -> [Recipe] {
        guard let url = URL(string: recipiesListURL) else {
            throw RecipeServiceError.invalidURL
        }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                throw RecipeServiceError.invalidResponse
            }

            let decodedData = try JSONDecoder().decode(RecipeResponse.self, from: data)
            return decodedData.recipes
        } catch {
            throw RecipeServiceError.dataFetchFailed(error.localizedDescription)
        }
    }
}

// Custom error handling
enum RecipeServiceError: Error, LocalizedError {
    case invalidURL
    case invalidResponse
    case dataFetchFailed(String)

    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "The API URL is invalid."
        case .invalidResponse:
            return "Received an invalid response from the server."
        case .dataFetchFailed(let message):
            return "Failed to fetch data: \(message)"
        }
    }
}
