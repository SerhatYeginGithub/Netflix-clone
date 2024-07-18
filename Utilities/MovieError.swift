//
//  MovieError.swift
//  Netflix-Clone
//
//  Created by serhat on 11.07.2024.
//

import Foundation

enum MovieError: String, Error {
    case invalidUrl = "This info created an invalid request. Please try again."
    case unableToComplete = "Unable to complete your request. Please check your internet connection"
    case invalidResponse = "Invalid response from the server. Please try again."
    case invalidData = "The data received from the server was invalid. Please try again."
}
