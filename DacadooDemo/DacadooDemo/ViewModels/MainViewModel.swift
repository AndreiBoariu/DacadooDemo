//
//  MainViewModel.swift
//  DacadooDemo
//
//  Created by Boariu Andy on 26.06.2024.
//

import Foundation

class MainViewModel {

    var images: [ImageData] = []
    var onLoadingStatusChanged: ((Bool) -> Void)?
    var onImagesChanged: (() -> Void)?
    var onErrorOccurred: ((String) -> Void)?

    func fetchImages(for query: String) {
        let urlString = "https://api.unsplash.com/search/photos?query=\(query)&client_id=NHr5nmnvy4fJA0AtfpReQm_EI2SBnnvPajDObRtmYbY"
        guard let url = URL(string: urlString) else { return }

        onLoadingStatusChanged?(true)

        URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            defer {
                DispatchQueue.main.async {
                    self.onLoadingStatusChanged?(false)
                }
            }

            if let data = data {
                do {
                    let result = try JSONDecoder().decode(UnsplashResult.self, from: data)

                    if result.results.isEmpty {
                        DispatchQueue.main.async {
                            self.onErrorOccurred?("No Results")
                        }
                        return
                    }

                    self.images = result.results.compactMap { result in
                        guard let thumbURL = URL(string: result.urls.thumb),
                              let fullURL = URL(string: result.urls.full) else {
                            return nil
                        }
                        return ImageData(thumbURL: thumbURL, fullURL: fullURL)
                    }

                    DispatchQueue.main.async {
                        self.onImagesChanged?()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.onErrorOccurred?("Failed to decode JSON: \(error.localizedDescription)")
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.onErrorOccurred?(error.localizedDescription)
                }
            }
        }.resume()
    }
}

