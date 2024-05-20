//
//  ImageCell.swift
//  DacadooDemo
//
//  Created by Boariu Andy on 20.05.2024.
//

import UIKit

class ImageCell: UITableViewCell {
    static let cellId = "ImageCellID"

    @IBOutlet weak var imgView: UIImageView!

    private var currentImageURL: URL?

    func loadImage(_ imageData: ImageData) {
        imgView.image = nil // Reset the image view
        currentImageURL = imageData.thumbURL

        let task = URLSession.shared.dataTask(with: imageData.thumbURL) { [weak self] data, response, error in
            guard let self = self else { return }
            if let data = data, error == nil {
                let image = UIImage(data: data)
                let resizedImage = self.resizeImage(image: image, targetWidth: 300)
                DispatchQueue.main.async {
                    if self.currentImageURL == imageData.thumbURL { // Ensure the image matches the cell's URL
                        self.imgView.image = resizedImage
                    }
                }
            }
        }
        task.resume()

        // Accessibility
        imgView.accessibilityLabel = "Image"
        imgView.accessibilityHint = "Double-tap to view the image in full screen"
    }

    private func resizeImage(image: UIImage?, targetWidth: CGFloat) -> UIImage? {
        guard let image = image else { return nil }
        let size = image.size
        let widthRatio  = targetWidth  / size.width
        let newSize = CGSize(width: targetWidth, height: size.height * widthRatio)

        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        image.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
}



