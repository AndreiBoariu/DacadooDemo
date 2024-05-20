//
//  ImageDataTests.swift
//  DacadooDemoTests
//
//  Created by Boariu Andy on 20.05.2024.
//

import XCTest
@testable import DacadooDemo

class ImageDataTests: XCTestCase {

    func testImageDataInitialization() {
        // Given
        let thumbURL = URL(string: "https://example.com/thumb.jpg")!
        let fullURL = URL(string: "https://example.com/full.jpg")!

        // When
        let imageData = ImageData(thumbURL: thumbURL, fullURL: fullURL)

        // Then
        XCTAssertEqual(imageData.thumbURL, thumbURL)
        XCTAssertEqual(imageData.fullURL, fullURL)
    }
}

