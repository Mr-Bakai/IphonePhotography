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
    
    var lesson: Lesson?
    
    private(set) var lessons = [Lesson]()
    private var cancellables = Set<AnyCancellable>()
    
    @Published var lessonResponse: LessonsResponse?
    private var downloads: [URL: Download] = [:]
    
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    }()
    
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
                self.lessonResponse = response
                self.lessons = response.lessons
            }
        self.cancellables.insert(cancellable)
    }
    
    @MainActor
    func fetchPodcast() async throws {
        let url = URL(string: "https://itunes.apple.com/lookup?id=1386867488&media=podcast&entity=podcastEpisode&limit=5")!
        let (data, _) = try await URLSession.shared.data(from: url)
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        lessonResponse = try decoder.decode(LessonsResponse.self, from: data)
    }
    
    @MainActor
    func download(_ lesson: Lesson) async throws {
        print("@@ Download: \(lesson.id)")
        guard downloads[lesson.url] == nil else { return }
        let download = Download(url: lesson.url, downloadSession: downloadSession)
        downloads[lesson.url] = download
        lessonResponse?[lesson.id]?.isDownloading = true
        for await event in download.events {
            process(event, for: lesson)
        }
        downloads[lesson.url] = nil
    }
    
    func pauseDownload(for lesson: Lesson) {
        print("@@ Pause Download: \(lesson.id)")
        downloads[lesson.url]?.pause()
        lessonResponse?[lesson.id]?.isDownloading = false
    }
    
    func resumeDownload(for lesson: Lesson) {
        print("@@ Resume Download: \(lesson.id)")
        downloads[lesson.url]?.resume()
        lessonResponse?[lesson.id]?.isDownloading = true
    }
}

private extension LessonsViewModelImpl {
    func process(_ event: Download.Event, for lesson: Lesson) {
        switch event {
        case let .progress(current, total):
            lessonResponse?[lesson.id]?.update(currentBytes: current, totalBytes: total)
        case let .success(url):
            saveFile(for: lesson, at: url)
        }
        
    }
    
    func saveFile(for lesson: Lesson, at url: URL) {
        guard let directoryURL = lessonResponse?.directoryURL else { return }
        let filemanager = FileManager.default
        if !filemanager.fileExists(atPath: directoryURL.path) {
            try? filemanager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
        }
        try? filemanager.moveItem(at: url, to: lesson.fileURL)
    }
}

extension LessonsResponse {
    var directoryURL: URL {
       FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("lessons") // TODO: BAKAI, fix me
    }
}

extension Lesson {
    var fileURL: URL {
       FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("lessons")
            .appendingPathComponent("\(id)")
            .appendingPathExtension(for: .mpeg4Movie)
    }
}

// TODO: BAKAI
// 1 -> After saving it should not be downloading again
