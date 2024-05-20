//
//  UnsplashResult.swift
//  DacadooDemo
//
//  Created by Boariu Andy on 20.05.2024.
//

import Foundation

struct UnsplashResult: Codable {
    let results: [UnsplashImage]
}

struct UnsplashImage: Codable {
    let urls: Urls
}

struct Urls: Codable {
    let thumb: String
    let full: String
}
