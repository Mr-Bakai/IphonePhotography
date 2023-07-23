//
//  LessonDetailsViewControllerRepresentable.swift
//  IphonePhotography
//
//  Created by Bakai on 17/7/23.
//

import SwiftUI

struct LessonDetailsViewControllerView: UIViewControllerRepresentable {
    
    private let lesson: Lesson
    
    init(lesson: Lesson) {
        self.lesson = lesson
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return LessonDetailsViewController(lesson: self.lesson)
    }
}
