//
//  MockRecipeService.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import Foundation
@testable import RecipeList

class MockRecipeService: RecipeServiceProtocol {
    var shouldFail = false

    func fetchRecipes() async throws -> [Recipe] {
        if shouldFail {
            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Mock error"])
        }
        return [
            Recipe(id: UUID(), cuisine: "Italian", name: "Test Recipe", photoURLSmall: nil, photoURLLarge: nil, sourceURL: nil, youtubeURL: nil)
        ]
    }
}
