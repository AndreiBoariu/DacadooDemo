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

}

