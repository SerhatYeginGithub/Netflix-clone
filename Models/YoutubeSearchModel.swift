//
//  YoutubeSearchModel.swift
//  Netflix-Clone
//
//  Created by serhat on 13.07.2024.
//

import Foundation

struct YoutubeSearchModel: Codable {
    let items: [VideoElement]
}

struct VideoElement: Codable{
    let id: IdVideoElement
}

struct IdVideoElement: Codable {
    let kind: String
    let videoId: String?
}
