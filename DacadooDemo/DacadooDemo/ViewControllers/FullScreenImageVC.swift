//
//  FullScreenImageVC.swift
//  DacadooDemo
//
//  Created by Boariu Andy on 20.05.2024.
//

import UIKit

class FullScreenImageVC: UIViewController {

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var imageURL: URL?

    private var dataTask: URLSessionDataTask?

    // MARK: - View Lifecyle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadImage()
    }

    // MARK: - Custom Methods
    private func loadImage() {
        guard let url = imageURL else { return }

        activityIndicator.startAnimating()

        // Cancel any existing data task to avoid duplicate downloads
        dataTask?.cancel()

        // Create a new data task to fetch the image
        dataTask = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }

            DispatchQueue.main.async {
                self.activityIndicator.stopAnimating()
                self.activityIndicator.removeFromSuperview()
            }

            if let error = error {
                print("Error fetching image: \(error)")
                return
            }

            guard let data = data, let image = UIImage(data: data) else {
                print("Invalid image data")
                return
            }

            DispatchQueue.main.async {
                self.imageView.image = image
            }
        }

        // Start the data task
        dataTask?.resume()
    }

    // MARK: - Memory Management Methods
    deinit {
        // Cancel the data task when the view controller is deallocated
        dataTask?.cancel()
    }
}

