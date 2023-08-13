//
//  Download.swift
//  IphonePhotography
//
//  Created by Bakai on 24/7/23.
//

import Foundation

class Download: NSObject {
    let url: URL
    let downloadSession: URLSession

    private var continuation: AsyncStream<Event>.Continuation?

    private lazy var task: URLSessionDownloadTask = {
        let task = downloadSession.downloadTask(with: url)
        task.delegate = self
        return task
    }()

    init(url: URL, downloadSession: URLSession) {
        self.url = url
        self.downloadSession = downloadSession
    }

    var isDownloading: Bool {
        task.state == .running
    }

    var events: AsyncStream<Event> {
        AsyncStream { continuation in
            self.continuation = continuation
            task.resume()
            continuation.onTermination = { @Sendable [weak self] _ in
                self?.task.cancel()
            }
        }
    }

    func pause() {
        task.suspend()
    }

    func resume() {
        task.resume()
    }
}

extension Download {
    enum Event {
        case progress(currentBytes: Int64, totalBytes: Int64)
        case success(url: URL)
    }
}

extension Download: URLSessionDownloadDelegate {
    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didWriteData bytesWritten: Int64,
        totalBytesWritten: Int64,
        totalBytesExpectedToWrite: Int64
    ) {
        continuation?.yield(
            .progress(
                currentBytes: totalBytesWritten,
                totalBytes: totalBytesExpectedToWrite))
        
        print("@@ totalBytesWritten: \(totalBytesWritten)")
        print("@@ totalBytesExpectedToWrite: \(totalBytesExpectedToWrite)")
    }

    func urlSession(
        _ session: URLSession,
        downloadTask: URLSessionDownloadTask,
        didFinishDownloadingTo location: URL
    ) {
        print("@@ Location: \(location)")
        
        let filemanager = FileManager.default
        
        var directoryURL: URL {
           FileManager
                .default
                .urls(for: .documentDirectory, in: .userDomainMask)[0]
                .appendingPathComponent("lessons")
        }
        
        do {
            let documentsURL = try
            FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: false
            )
            
            let savedURL = documentsURL
                .appendingPathComponent("lessons")
                .appendingPathComponent(location.lastPathComponent)
                .appendingPathExtension(for: .mpeg4Movie)
            
            if !filemanager.fileExists(atPath: directoryURL.path) {
                try? filemanager.createDirectory(at: directoryURL, withIntermediateDirectories: true)
            }
            
            try FileManager.default.moveItem(at: location, to: savedURL)
            continuation?.yield(.success(url: savedURL))
        } catch {
            // TODO: BAKAI, FIX ME, return appropriate Error case
        }
        continuation?.finish()
    }
}
