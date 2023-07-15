//
//  LessonsEndpoint.swift
//  IphonePhotography
//
//  Created by Bakai on 15/7/23.
//

import Foundation

protocol APIBuilder {
    var urlRequest: URLRequest { get }
    var baseUrl: URL { get }
    var path: String { get }
}

enum LessonsAPI {
    case getLessons
}

extension LessonsAPI: APIBuilder {
    var baseUrl: URL {
        switch self {
        case .getLessons:
            return URL(string: "https://iphonephotographyschool.com/test-api")!
        }
    }
    
    var urlRequest: URLRequest {
        return URLRequest(url: self.baseUrl.appendingPathComponent(self.path))
    }
    
    var path: String {
        return "/lessons"
    }
}
