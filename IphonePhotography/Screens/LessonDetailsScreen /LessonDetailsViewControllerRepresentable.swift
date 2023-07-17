//
//  LessonDetailsViewControllerRepresentable.swift
//  IphonePhotography
//
//  Created by Bakai on 17/7/23.
//

import SwiftUI


struct LessonDetailsViewControllerView: UIViewControllerRepresentable {
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    func makeUIViewController(context: Context) -> some UIViewController {
        return LessonDetailsViewController()
    }
}
