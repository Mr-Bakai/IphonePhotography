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
    let name, description: String?
    let thumbnail: String?
    let videoURL: String?

    enum CodingKeys: String, CodingKey {
        case id, name, description, thumbnail
        case videoURL = "video_url"
    }
}

// TODO: Mock Data to be removed later
extension Lesson {
    static let data =
    [
        Lesson(
            id: 1,
            name: "name",
            description: "desc",
            thumbnail: "asd",
            videoURL: "asdasd"
        ),
        Lesson(
            id: 2,
            name: "name",
            description: "desc",
            thumbnail: "asd",
            videoURL: "asdasd"
        ),
        Lesson(
            id: 3,
            name: "name",
            description: "desc",
            thumbnail: "asd",
            videoURL: "asdasd"
        ),
        Lesson(
            id: 4,
            name: "name",
            description: "desc",
            thumbnail: "asd",
            videoURL: "asdasd"
        ),
        Lesson(
            id: 5,
            name: "name",
            description: "desc",
            thumbnail: "asd",
            videoURL: "asdasd"
        ),
        Lesson(
            id: 6,
            name: "name",
            description: "desc",
            thumbnail: "asd",
            videoURL: "asdasd"
        )
    ]
}
