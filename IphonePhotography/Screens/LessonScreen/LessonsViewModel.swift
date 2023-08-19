//
//  LessonsViewModel.swift
//  IphonePhotography
//
//  Created by Bakai on 16/7/23.
//

import Foundation
import Combine
import SwiftUI

protocol LessonsViewModel {
    func getLessons()
}

final class LessonsViewModelImpl: ObservableObject, LessonsViewModel {
    
    private let service: LessonsService
    private let fileManager = FileManager.default
    
    var lesson: Lesson?
    private(set) var lessons = [Lesson]()
    @Published var lessonResponse: LessonsResponse?
    
    private var cancellables = Set<AnyCancellable>()
    private var downloads: [URL: Download] = [:]
    
    private lazy var downloadSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        return URLSession(configuration: configuration, delegate: nil, delegateQueue: .main)
    }()
    
    @Published private(set) var state: ResultState = .loading
    @Published var isSheetPresented: Bool = false
    @Published var errorMessage = ""
    
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
                    self.isSheetPresented = true
                    self.errorMessage = error.errorDescription ?? "Error"
                }
                
            } receiveValue: { response in
                self.lessonResponse = response
                self.lessons = response.lessons
            }
        self.cancellables.insert(cancellable)
    }
    
    @MainActor
    func download(_ lesson: Lesson) async throws {
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
        downloads[lesson.url]?.pause()
        lessonResponse?[lesson.id]?.isDownloading = false
    }
    
    func resumeDownload(for lesson: Lesson) {
        downloads[lesson.url]?.resume()
        lessonResponse?[lesson.id]?.isDownloading = true
    }
    
    func fetchFromStore() {
        do {
            let items = try fileManager.contentsOfDirectory(
                at: self.lessonsDirectory,
                includingPropertiesForKeys: nil,
                options: [.skipsHiddenFiles]
            )
            
            for item in items {
                matchData(itemUrl: item)
            }
            
        } catch {}
    }
    
    private func matchData(itemUrl: URL) {
        DispatchQueue.global(qos: .background).async {
            do {
                let documentsPath = try self.getItemURLFromLessonsDataDirectory(itemUrl)
                guard let file = try? FileHandle(forReadingFrom: documentsPath) else { return }
                
                let item = try JSONDecoder().decode(Lesson.self, from: file.availableData)
                
                if item.id == Int(itemUrl.deletingPathExtension().lastPathComponent) {
                    var copyItem = item
                    copyItem.videoURL = itemUrl.absoluteString
                    self.lessons.append(copyItem)
                }
                
                DispatchQueue.main.async {
                    self.state = .success(content: self.lessons)
                }
                
            } catch {}
        }
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
        DispatchQueue.global(qos: .background).async {
            try? self.fileManager.moveItem(at: url, to: lesson.fileURL)
            
            do {
                let data = try JSONEncoder().encode(lesson)
                let outfile = try self.getItemURLToSaveIntoLessonsDataDirectory(lesson)
                
                if !self.fileManager.fileExists(atPath: self.lessonsDataDirectory.path) {
                    try? self.fileManager.createDirectory(at: self.lessonsDataDirectory, withIntermediateDirectories: true)
                }
                try data.write(to: outfile)
                
            } catch {}
        }
    }
}

extension LessonsResponse {
    var directoryURL: URL {
        FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("lessons")
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

extension LessonsViewModelImpl {
    var lessonsDirectory: URL{
        FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("lessons")
    }
}

extension LessonsViewModelImpl {
    var lessonsDataDirectory: URL {
       FileManager
            .default
            .urls(for: .documentDirectory, in: .userDomainMask)[0]
            .appendingPathComponent("lessonsData")
    }
}

extension LessonsViewModelImpl {
    func getItemURLFromLessonsDataDirectory(_ itemUrl: URL) throws -> URL {
        return try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
            .appendingPathComponent("lessonsData")
            .appendingPathComponent(itemUrl.deletingPathExtension().lastPathComponent)
    }
}

extension LessonsViewModelImpl {
    func getItemURLToSaveIntoLessonsDataDirectory(_ lesson: Lesson) throws -> URL {
        return try FileManager.default.url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
            .appendingPathComponent("lessonsData")
            .appendingPathComponent("\(lesson.id)")
    }
}



// TODO: BAKAI
// 1 -> After saving it should not be downloading again
// 2 -> This viewModel to be Refactored
// Continue on: Refactor the item matching thingy, it is worked well body!!!!
