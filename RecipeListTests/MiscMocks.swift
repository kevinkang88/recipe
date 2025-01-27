//
//  MockRecipeService.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import Foundation
import UIKit
@testable import RecipeList

class MockRecipeService: RecipeServiceProtocol {
    var shouldFail = false

    func fetchRecipes() async throws -> [Recipe] {
        if shouldFail {
            throw NSError(
                domain: "",
                code: -1,
                userInfo: [NSLocalizedDescriptionKey: "Mock error"]
            )
        }
        return [
            Recipe(
                id: UUID(),
                cuisine: "Italian",
                name: "Test Recipe",
                photoURLSmall: nil,
                photoURLLarge: nil,
                sourceURL: nil,
                youtubeURL: nil
            )
        ]
    }

    func fetchImage(from url: URL) async throws -> Data {
        guard let image = UIImage(systemName: "star.fill"),
              let imageData = image.pngData() else {
            throw RecipeServiceError.invalidURL
        }
        return imageData
    }
}

final class MockImageCacheService: ImageCacheProtocol {
    private var mockCache: [URL: UIImage] = [:]

    func getImage(for url: URL) -> UIImage? {
        return mockCache[url]
    }

    func saveImage(_ image: UIImage, for url: URL) {
        mockCache[url] = image
    }
}
