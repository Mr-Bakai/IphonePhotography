//
//  LessonsService.swift
//  IphonePhotography
//
//  Created by Bakai on 15/7/23.
//

import Foundation
import Combine

protocol LessonsApi {
    func request(from endpoint: LessonsAPI) -> AnyPublisher<LessonsResponse, APIError>
}

struct LessonsServiceImpl: LessonsApi {
    
    func request(from endpoint: LessonsAPI) -> AnyPublisher<LessonsResponse, APIError> {
        return URLSession
            .shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .receive(on: DispatchQueue.main)
            .mapError { _ in APIError.unknown }
            .flatMap { data, response -> AnyPublisher<LessonsResponse, APIError> in
                
                guard let response = response as? HTTPURLResponse else {
                    return Fail(error: APIError.unknown).eraseToAnyPublisher()
                }
                
                if (200...299).contains(response.statusCode) {
                    let jsonDecoder = JSONDecoder()
                    jsonDecoder.dateDecodingStrategy = .iso8601
                    
                    return Just(data)
                        .decode(type: LessonsResponse.self, decoder: jsonDecoder)
                        .mapError { _ in APIError.decodingError }
                        .eraseToAnyPublisher()
                    
                } else {
                    return Fail(error: APIError.errorCode(response.statusCode)).eraseToAnyPublisher()
                }
            }
            .eraseToAnyPublisher()
    }
}
