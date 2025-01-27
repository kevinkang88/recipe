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
    private let imageCache: ImageCacheProtocol

    private var allRecipes: [Recipe] = []
    private let pageSize = 15
    private var currentPage = 0

    init(service: RecipeServiceProtocol, imageCache: ImageCacheProtocol) {
        self.service = service
        self.imageCache = imageCache
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

    func cachedImage(for url: URL) -> UIImage? {
        imageCache.getImage(for: url)
    }

    func saveImage(_ image: UIImage, for url: URL) {
        imageCache.saveImage(image, for: url)
    }

    func loadImage(for url: URL) async -> UIImage? {
        if let cachedImage = imageCache.getImage(for: url) {
            return cachedImage
        }

        do {
            let imageData = try await service.fetchImage(from: url)
            if let downloadedImage = UIImage(data: imageData) {
                imageCache.saveImage(downloadedImage, for: url)
                return downloadedImage
            }
        } catch {
            print("Failed to download image: \(error.localizedDescription)")
        }
        return nil
    }
}
