//
//  DisableSwipeBackView.swift
//  IphonePhotography
//
//  Created by Bakai on 19/8/23.
//

import SwiftUI

public struct DisableSwipeBackView: UIViewControllerRepresentable {
    
    public typealias  UIViewControllerType = DisableSwipeBackViewController
    
    
    public func makeUIViewController(context: Context) -> UIViewControllerType {
        UIViewControllerType()
    }
    
    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

public class DisableSwipeBackViewController: UIViewController {
    override public func didMove(toParent parent: UIViewController?) {
        super.didMove(toParent: parent)
        if let parent = parent?.parent,
           let navigationController = parent.navigationController,
           let interactivePopGestureRecognizer = navigationController.interactivePopGestureRecognizer {
            navigationController.view.removeGestureRecognizer(interactivePopGestureRecognizer)
        }
    }
}
