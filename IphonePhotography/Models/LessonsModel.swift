//
//  LessonsModel.swift
//  IphonePhotography
//
//  Created by Bakai on 15/7/23.
//

import Foundation

struct LessonsResponse: Codable {
    var lessons: [Lesson]
    
    subscript(lessondID: Int) -> Lesson? {
        get {
            lessons.first { $0.id == lessondID }
        }
        set {
            guard let newValue,
                  let index = lessons.firstIndex(where: { $0.id == lessondID })
            else { return }
            lessons[index] = newValue
        }
    }
}

struct Lesson: Codable {
    let id: Int
    let name, description: String?
    let thumbnail: String?
    let videoURL: String?
    var url: URL {
        guard
            let videoURL,
            let url = URL(string: videoURL) else {
            return URL(string: "TODO/CHANGE")!
        }
        return url
    }
    
    var isDownloading: Bool = false
    private(set) var currentBytes: Int64 = 0
    private(set) var totalBytes: Int64 = 0
    
    var progress: Double {
        guard totalBytes > 0 else { return 0.0 }
        return Double(currentBytes) / Double(totalBytes)
    }
    
    mutating func update(currentBytes: Int64, totalBytes: Int64) {
        self.currentBytes = currentBytes
        self.totalBytes = totalBytes
    }

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
