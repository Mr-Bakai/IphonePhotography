//
//  LessonDetailsViewController.swift
//  IphonePhotography
//
//  Created by Bakai on 17/7/23.
//

import UIKit
import SwiftUI
import SnapKit
import URLImage

class LessonDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    private var lesson: Lesson
    
    private let toolbar: UIToolbarView = {
        let view = UIToolbarView(title: "Lessons")
        return view
    }()
    
    private let imageCover: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    init(lesson: Lesson) {
        self.lesson = lesson
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let thumbnail = UIHostingController(rootView: ImagePlaceholder(lesson: lesson)).view ?? UIView()
        
        view.addSubview(thumbnail)
        thumbnail.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
        }
    }
}

struct LessonDetailsViewController_Previews: PreviewProvider {
    private static let lesson: Lesson = Lesson(
        id: 0,
        name: "",
        description: "",
        thumbnail: "",
        videoURL: ""
    )
    
    static var previews: some View {
        LessonDetailsViewControllerView(lesson: lesson)
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
