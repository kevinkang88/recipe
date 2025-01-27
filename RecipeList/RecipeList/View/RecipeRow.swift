//
//  RecipeRow.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import SwiftUI

struct RecipeRow: View {
    let recipe: Recipe
    @ObservedObject var viewModel: RecipeListViewModel
    @State private var image: UIImage?

    var body: some View {
        HStack {
            if let url = recipe.photoURLSmall {
                if let cachedImage = image {
                    // SwiftUI provides AsyncImage but for purpose of explicit implementation of caching use Image
                    Image(uiImage: cachedImage)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 80, height: 80)
                        .cornerRadius(8)
                } else {
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .task {
                            await loadImage(url)
                        }
                }
            }

            VStack(alignment: .leading) {
                Text(recipe.name)
                    .font(.headline)
                Text(recipe.cuisine)
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }

    private func loadImage(_ url: URL) async {
        if let fetchedImage = await viewModel.loadImage(for: url) {
            image = fetchedImage
        }
    }
}
