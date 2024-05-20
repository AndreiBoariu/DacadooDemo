//
//  MainVCTests.swift
//  DacadooDemoTests
//
//  Created by Boariu Andy on 20.05.2024.
//

import XCTest
@testable import DacadooDemo

class MainVCTests: XCTestCase {

    var mainVC: MainVC!

    override func setUp() {
        super.setUp()
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        mainVC = storyboard.instantiateViewController(withIdentifier: "MainVC") as? MainVC
        mainVC.loadViewIfNeeded() // Ensure the view is loaded
    }

    override func tearDown() {
        mainVC = nil
        super.tearDown()
    }

    func testFetchImagesSuccess() {
        // Given
        let query = "iPhone"
        let expectation = XCTestExpectation(description: "Fetch images for query")

        // When
        mainVC.fetchImages(for: query)

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertFalse(self.mainVC.images.isEmpty)
            expectation.fulfill()
        }

        wait(for: [expectation], timeout: 10)
    }

    func testDismissKeyboard() {
        // Given
        let textField = UITextField()
        mainVC.view.addSubview(textField)
        textField.becomeFirstResponder() // Make the text field the first responder

        // When
        mainVC.dismissKeyboard()

        // Then
        XCTAssertFalse(textField.isFirstResponder)
    }

//    func testShowAlert() {
//        // Given
//        let title = "Test Title"
//        let message = "Test Message"
//
//        // When
//        mainVC.showAlert(with: title, message: message)
//
//        // Then
//        let expectation = XCTestExpectation(description: "Alert presented")
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { // Delay for alert presentation
//            let presentedViewController = self.mainVC.presentedViewController as? UIAlertController
//            XCTAssertNotNil(presentedViewController)
//            XCTAssertEqual(presentedViewController?.title, title)
//            XCTAssertEqual(presentedViewController?.message, message)
//            expectation.fulfill()
//        }
//
//        wait(for: [expectation], timeout: 5)
//    }


    func testSearchButtonTappedFromKeyboard() {
        // Given
        let expectation = XCTestExpectation(description: "Search button tapped from keyboard")

        // Set up an expectation for the action to be called
        mainVC.btnSearch.addTarget(mainVC, action: #selector(MainVC.searchButtonTapped(_:)), for: .touchUpInside)

        // When
        mainVC.searchButtonTappedFromKeyboard()

        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            expectation.fulfill()
        }

        // Wait for the expectation to be fulfilled
        wait(for: [expectation], timeout: 1)
    }
}

