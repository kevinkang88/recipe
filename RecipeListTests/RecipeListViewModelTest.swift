//
//  RecipeListViewModelTest.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import Foundation
import SwiftUI
@testable import RecipeList
import XCTest

final class RecipeListViewModelTests: XCTestCase {
    
    var viewModel: RecipeListViewModel!
    var mockService: MockRecipeService!
    var mockCache: MockImageCacheService!
    
    @MainActor
    override func setUp() {
        super.setUp()
        mockService = MockRecipeService()
        mockCache = MockImageCacheService()
        viewModel = RecipeListViewModel(service: mockService, imageCache: mockCache)
    }

    @MainActor
    override func tearDown() {
        viewModel = nil
        mockService = nil
        mockCache = nil
        super.tearDown()
    }
    
    @MainActor
    func testFetchRecipesSuccess() async {
        let mockService = MockRecipeService()
        let viewModel = RecipeListViewModel(service: mockService, imageCache: mockCache)

        await viewModel.fetchRecipes()

        XCTAssertEqual(viewModel.displayedRecipes.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    @MainActor
    func testImageLoadingWithMockedService() async throws {
        let testURL = try XCTUnwrap(URL(string: "https://example.com/image.jpg"), "invalid url")

        let loadedImage = await viewModel.loadImage(for: testURL)

        XCTAssertNotNil(loadedImage, "Image should be successfully loaded")

        let cachedImage = viewModel.cachedImage(for: testURL)
        XCTAssertNotNil(cachedImage, "Image should be cached")
    }

    @MainActor
    func testImageCacheRetrieval() throws {
        let testURL = try XCTUnwrap(URL(string: "https://example.com/image.jpg"), "invalid url")
        let testImage = try XCTUnwrap(UIImage(systemName: "star.fill"), "invalid image")
        viewModel.saveImage(testImage, for: testURL)

        let cachedImage = viewModel.cachedImage(for: testURL)
        XCTAssertNotNil(cachedImage, "Cached image should be retrieved successfully")
    }
}
