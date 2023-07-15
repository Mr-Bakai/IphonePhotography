//
//  ResultState.swift
//  IphonePhotography
//
//  Created by Bakai on 16/7/23.
//

import Foundation

enum ResultState {
    case loading
    case success(content: [Lesson])
    case failed(error: Error)
}
