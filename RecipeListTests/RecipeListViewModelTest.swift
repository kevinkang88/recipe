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
    
    @MainActor
    func testFetchRecipesSuccess() async {
        let mockService = MockRecipeService()
        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.fetchRecipes()

        XCTAssertEqual(viewModel.displayedRecipes.count, 1)
        XCTAssertNil(viewModel.errorMessage)
    }
    
    @MainActor
    func testFetchRecipesFailure() async {
        let mockService = MockRecipeService()
        mockService.shouldFail = true
        let viewModel = RecipeListViewModel(service: mockService)

        await viewModel.fetchRecipes()

        XCTAssertNotNil(viewModel.errorMessage)
        XCTAssertTrue(viewModel.displayedRecipes.isEmpty)
    }
}
