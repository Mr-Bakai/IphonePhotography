//
//  LessonsModel.swift
//  IphonePhotography
//
//  Created by Bakai on 15/7/23.
//

import Foundation

struct LessonsResponse: Codable {
    let lessons: [Lesson]
}

struct Lesson: Codable {
    let id: Int
    let name, description: String
    let thumbnail: String
    let videoURL: String

    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail
        case videoURL = "video_url"
    }
}
