//
//  ImageCache.swift
//  RecipeList
//
//  Created by Dong Kevin Kang on 1/27/25.
//

import UIKit

protocol ImageCacheProtocol {
    func getImage(for url: URL) -> UIImage?
    func saveImage(_ image: UIImage, for url: URL)
}

final class ImageCacheService: ImageCacheProtocol {
    private let memoryCache = NSCache<NSURL, UIImage>()
    private let diskCacheDirectory: URL?

    init() {
        diskCacheDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("RecipeImageCache")

        if let directory = diskCacheDirectory {
            do {
                try FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
            } catch {
                print("Failed to create cache directory:", error.localizedDescription)
            }
        } else {
            print("Failed to locate cache directory.")
        }
    }

    func getImage(for url: URL) -> UIImage? {
        if let memoryImage = memoryCache.object(forKey: url as NSURL) {
            return memoryImage
        }

        guard let diskImage = loadFromDisk(for: url) else { return nil }
        memoryCache.setObject(diskImage, forKey: url as NSURL)
        return diskImage
    }

    func saveImage(_ image: UIImage, for url: URL) {
        memoryCache.setObject(image, forKey: url as NSURL)

        guard let encodedFileName = url.absoluteString.addingPercentEncoding(withAllowedCharacters: .alphanumerics),
              let fileURL = diskCacheDirectory?.appendingPathComponent(encodedFileName),
              let data = image.jpegData(compressionQuality: 0.8) else {
            return
        }

        do {
            try data.write(to: fileURL)
        } catch {
            print("Error saving image to disk:", error.localizedDescription)
        }
    }

    private func loadFromDisk(for url: URL) -> UIImage? {
        guard let fileURL = diskCacheDirectory?.appendingPathComponent(url.lastPathComponent),
              let data = try? Data(contentsOf: fileURL) else {
            return nil
        }
        return UIImage(data: data)
    }
}
