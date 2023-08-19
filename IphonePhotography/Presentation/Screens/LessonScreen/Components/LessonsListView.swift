//
//  LessonsCollection.swift
//  IphonePhotography
//
//  Created by Bakai on 15/7/23.
//

import SwiftUI

// TODO: BAKAI, to be refactored
struct LessonsListView: View {
    
    @EnvironmentObject var lessonViewModel: LessonsViewModelImpl
    
    private var lessons: [Lesson]
    
    init(lessons: [Lesson]) {
        self.lessons = lessons
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(lessons, id: \.id) { item in
                    NavigationLink(destination: makeLessonDetailsVC(item)) {
                        HStack {
                            ImagePlaceholder(lesson: item)
                                .cornerRadius(6)
                            Text(item.name ?? "None")
                                .fontWeight(.semibold)
                                .lineLimit(2)
                                .minimumScaleFactor(0.5)
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Lessons")
        }
    }
    
    private func makeLessonDetailsVC(_ lesson: Lesson) -> some View {
        LessonDetailsViewControllerView(
            lesson: lesson,
            lessonViewModel: lessonViewModel
        )
        .navigationBarTitleDisplayMode(.inline)
        .edgesIgnoringSafeArea(.bottom)
        .toolbar {
            getToolbar(lesson)
        }
    }
    
    func getToolbar(_ lesson: Lesson) -> some ToolbarContent {
        Group {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    let _ = print("@@ lesson: \(lesson)")
                    toggleDownload(for: lesson)
                } label: {
                    HStack {
                        Image("cloud_download")
                            .resizable()
                            .renderingMode(.template)
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                        
                        Text("Download")
                        
                        let _ = print("@@ Progress: \(progress)")
                        
                        if progress > 0 && progress < 1.0 {
                            ProgressView(value: progress)
                        }
                    }
                }
            }
        }
    }
}

private extension LessonsListView {
    var progress: Double {
        guard let lesson = lessonViewModel.lesson else { return 0.0 }
        return lessonViewModel.lessonResponse?[lesson.id]?.progress ?? 0.0
    }
    
    var buttonImageName: String {
        switch (progress, lessonViewModel.lesson?.isDownloading ?? false) {
        case (1.0, _): return "checkmark.circle.fill"
        case (_, true): return "pause.fill"
        default: return "tray.and.arrow.down"
        }
    }
}

private extension LessonsListView {
    func toggleDownload(for lesson: Lesson) {
        
        lessonViewModel.lesson = lesson
        let lesson = lessonViewModel.lessonResponse?[lesson.id]
        guard let lesson else { return }
        
        let _ = print("@@ lesson: \(lesson.id)")
        let _ = print("@@ lesson.isDownloading: \(lesson.isDownloading)")
        
        if lesson.isDownloading {
            lessonViewModel.pauseDownload(for: lesson)
        } else {
            if lesson.progress > 0 {
                lessonViewModel.resumeDownload(for: lesson)
            } else {
                Task { try? await lessonViewModel.download(lesson) }
            }
        }
    }
}

struct LessonsCollection_Previews: PreviewProvider {
    static var previews: some View {
        LessonsListView(lessons: Lesson.data)
    }
}
