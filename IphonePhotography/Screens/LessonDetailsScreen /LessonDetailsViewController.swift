//
//  LessonDetailsViewController.swift
//  IphonePhotography
//
//  Created by Bakai on 17/7/23.
//

import UIKit
import SwiftUI

class LessonDetailsViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .cyan
    }
}

struct LessonDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailsViewControllerView().edgesIgnoringSafeArea(.all)
    }
}


extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}

/// You can place this extension wherever as it will be overriding
/// the view did load of any navigation controller used in your app
