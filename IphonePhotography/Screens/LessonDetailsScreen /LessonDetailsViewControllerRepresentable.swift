//
//  LessonDetailsViewControllerRepresentable.swift
//  IphonePhotography
//
//  Created by Bakai on 17/7/23.
//

import SwiftUI

struct LessonDetailsViewControllerView: UIViewControllerRepresentable {
    
    private var lessonViewModel: LessonsViewModelImpl
    private let lesson: Lesson
    
    init(lesson: Lesson, lessonViewModel: LessonsViewModelImpl) {
        self.lesson = lesson
        self.lessonViewModel = lessonViewModel
        self.lessonViewModel.lesson = lesson
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return LessonDetailsViewController(lesson: lesson, lessonViewModel: lessonViewModel)
    }
}
