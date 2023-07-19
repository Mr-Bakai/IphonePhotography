//
//  LessonDetailsViewController.swift
//  IphonePhotography
//
//  Created by Bakai on 17/7/23.
//

import UIKit
import SwiftUI
import SnapKit

class LessonDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private let toolbar: UIToolbarView = {
        let view = UIToolbarView(title: "Lessons")
        return view
    }()
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .brown
        
        view.addSubview(toolbar)
//        toolbar.snp.makeConstraints { make in
//            make.width.equalToSuperview()
//            make.top.equalToSuperview()
//            make.height.equalTo(44)
//        }
//
//        toolbar.backImageTapped = { [weak self] in
//            guard let self else { return }
//            print("Back Image Tapped")
//        }
    }
}

struct LessonDetailsViewController_Previews: PreviewProvider {
    static var previews: some View {
        LessonDetailsViewControllerView()
    }
}


/// You can place this extension wherever as it will be overriding
/// the view did load of any navigation controller used in your app

extension UINavigationController: UIGestureRecognizerDelegate {
    override open func viewDidLoad() {
        super.viewDidLoad()
        interactivePopGestureRecognizer?.delegate = self
    }

    public func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return viewControllers.count > 1
    }
}
