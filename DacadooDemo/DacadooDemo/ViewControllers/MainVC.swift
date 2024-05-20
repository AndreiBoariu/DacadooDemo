//
//  MainVC.swift
//  DacadooDemo
//
//  Created by Boariu Andy on 20.05.2024.
//
import UIKit

class MainVC: UIViewController {

    @IBOutlet weak var txfSearch: UITextField!
    @IBOutlet weak var btnSearch: UIButton!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    var images: [ImageData] = []

    // MARK: - View Lifecyle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupAccessibility()
    }

    // MARK: - Custom Methods

    private func setupUI() {
        tableView.rowHeight = 170.0

        activityIndicator.isHidden = true // Hide the activity indicator initially

        // Add a target to the text field for the search button on the keyboard
        txfSearch.addTarget(self, action: #selector(searchButtonTappedFromKeyboard), for: .editingDidEndOnExit)
    }

    private func setupAccessibility() {
        txfSearch.accessibilityLabel = "Search Text Field"
        txfSearch.accessibilityHint = "Enter a search term here"

        btnSearch.accessibilityLabel = "Search Button"
        btnSearch.accessibilityHint = "Tap to search for images"

        activityIndicator.accessibilityLabel = "Loading Indicator"
        activityIndicator.accessibilityHint = "Indicates that content is loading"

        tableView.accessibilityLabel = "Image Results"
        tableView.accessibilityHint = "Displays search results as a list of images"
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func stopLoadingUI() {
        activityIndicator.stopAnimating()
        activityIndicator.isHidden = true
        btnSearch.isHidden = false
    }

    // MARK: - Action Methods
    @IBAction func searchButtonTapped(_ sender: UIButton) {
        guard let query = txfSearch.text, !query.isEmpty else {
            showAlert(with: "Input Field Empty", message: "What did one ocean say to the other ocean? \n\nNothing, they just waved! 👋🏻")
            return
        }

        dismissKeyboard()

        // Add haptic feedback
        let generator = UIImpactFeedbackGenerator(style: .medium)
        generator.impactOccurred()

        // Show the activity indicator and hide the search button
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        btnSearch.isHidden = true

        // Call API
        fetchImages(for: query)
    }

    @objc func searchButtonTappedFromKeyboard() {
        // Call the same action as the main search button when the search button on the keyboard is tapped
        searchButtonTapped(btnSearch)
    }

    // MARK: - API Methods
    func fetchImages(for query: String) {
        let urlString = "https://api.unsplash.com/search/photos?query=\(query)&client_id=NHr5nmnvy4fJA0AtfpReQm_EI2SBnnvPajDObRtmYbY"
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let result = try JSONDecoder().decode(UnsplashResult.self, from: data)

                    self.images = result.results.compactMap { result in
                        guard let thumbURL = URL(string: result.urls.thumb),
                              let fullURL = URL(string: result.urls.full) else {
                            return nil
                        }

                        return ImageData(thumbURL: thumbURL, fullURL: fullURL)
                    }

                    DispatchQueue.main.async {
                        self.tableView.reloadData()
                        self.stopLoadingUI()
                    }
                } catch {
                    DispatchQueue.main.async {
                        self.showAlert(with: "Failed to decode JSON", message: error.localizedDescription)
                        self.stopLoadingUI()
                    }
                }
            } else if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(with: "Error", message: error.localizedDescription)
                    self.stopLoadingUI()
                }
            }
        }.resume()
    }
}

// MARK: - UITableViewDelegate Methods
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.cellId, for: indexPath) as! ImageCell
        let imageData = images[indexPath.row]
        cell.loadImage(imageData)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Add haptic feedback
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()

        let selectedImage = images[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "FullScreenImageVC") as! FullScreenImageVC
        detailVC.imageURL = selectedImage.fullURL
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
}
