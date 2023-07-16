//
//  LessonsViewModel.swift
//  IphonePhotography
//
//  Created by Bakai on 16/7/23.
//

import Foundation
import Combine

protocol LessonsViewModel {
    func getLessons()
}

final class LessonsViewModelImpl: ObservableObject, LessonsViewModel {
    
    private let service: LessonsService
    
    private(set) var lessons = [Lesson]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published private(set) var state: ResultState = .loading
    
    init(service: LessonsService) {
        self.service = service
    }
    
    func getLessons() {
        self.state = .loading
        
        let cancellable = service
            .request(from: .getLessons)
            .sink { result in
                switch result {
                    
                case .finished:
                    self.state = .success(content: self.lessons)
                    
                case .failure(let error):
                    self.state = .failed(error: error)
                }
                
            } receiveValue: { response in
                self.lessons = response.lessons
            }
        self.cancellables.insert(cancellable)
    }
}
