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

    var viewModel = MainViewModel()

    // MARK: - View Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupAccessibility()
        bindViewModel()
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

    private func bindViewModel() {
        viewModel.onLoadingStatusChanged = { [weak self] isLoading in
            guard let self = self else { return }
            self.activityIndicator.isHidden = !isLoading
            self.btnSearch.isHidden = isLoading
            if isLoading {
                self.activityIndicator.startAnimating()
            } else {
                self.activityIndicator.stopAnimating()
            }
        }

        viewModel.onImagesChanged = { [weak self] in
            self?.tableView.reloadData()
        }

        viewModel.onErrorOccurred = { [weak self] errorMessage in
            self?.showAlert(with: "Error", message: errorMessage)
        }
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

    func showAlert(with title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
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

        viewModel.fetchImages(for: query)
    }

    @objc func searchButtonTappedFromKeyboard() {
        searchButtonTapped(btnSearch)
    }
}

// MARK: - UITableViewDelegate Methods
extension MainVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.images.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ImageCell.cellId, for: indexPath) as! ImageCell
        let imageData = viewModel.images[indexPath.row]
        cell.loadImage(imageData)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        // Add haptic feedback
        let generator = UISelectionFeedbackGenerator()
        generator.selectionChanged()

        let selectedImage = viewModel.images[indexPath.row]
        let detailVC = storyboard?.instantiateViewController(withIdentifier: "FullScreenImageVC") as! FullScreenImageVC
        detailVC.imageURL = selectedImage.fullURL
        navigationController?.pushViewController(detailVC, animated: true)
    }

    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return 170.0
    }
}

