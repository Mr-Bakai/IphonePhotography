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
import AVKit

// TODO: Show a “Download” button to start download for offline viewing
class LessonDetailsViewController: UIViewController, UIGestureRecognizerDelegate {
    
    private var lessonViewModel: LessonsViewModelImpl
    private var lesson: Lesson
    
    private let toolbar: UIToolbarView = {
        let view = UIToolbarView(title: "Lessons")
        return view
    }()
    
    private let playImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "play.fill")?
            .withTintColor(.white, renderingMode: .alwaysOriginal)
        return imageView
    }()
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.text = "The Key To Success in iPhone Photography"
        label.font = UIFont.boldSystemFont(ofSize: 32)
        label.numberOfLines = 0
        return label
    }()
    
    private var descriptionLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    init(lesson: Lesson, lessonViewModel: LessonsViewModelImpl) {
        self.lesson = lesson
        self.lessonViewModel = lessonViewModel
        super.init(nibName: nil, bundle: nil)
        self.configureUI()
    }
    
    private func configureUI() {
        self.titleLabel.text = lesson.name
        self.descriptionLabel.text = lesson.description
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
            make.width.equalToSuperview() // TODO: BAKAI, switch this
            make.height.equalTo(200)      // TODO: BAKAI, switch this
        }
        
        thumbnail.addSubview(playImage)
        playImage.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(40)
            make.height.equalTo(45)
        }
        
        view.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(thumbnail.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(8)
        }
        
        view.addSubview(descriptionLabel)
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(8)
        }
        
        let progressView = UIProgressView(progressViewStyle: .bar)
        progressView.trackTintColor = UIColor.lightGray
        progressView.tintColor = UIColor.blue
        
        view.addSubview(progressView)
        progressView.snp.makeConstraints { make in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(18)
            make.left.right.equalToSuperview().inset(8)
        }
        
        self.setupActions()
    }
    
    private func setupActions() {
        let playImageTap = UITapGestureRecognizer(target: self, action: #selector(playImageTapped))
        playImage.addGestureRecognizer(playImageTap)
        playImage.isUserInteractionEnabled = true
    }
    
    private func playVideo() {
        guard let url = lesson.videoURL,
              let videoURL = URL(string: url) else { return }
        
        let player = AVPlayer(url: videoURL)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player
        
        self.present(playerViewController, animated: true) {
            playerViewController.player?.play()
        }
    }
    
    @objc private func playImageTapped() {
        self.playVideo()
    }
}

private extension LessonDetailsViewController {
    var progress: Double {
        lesson.progress
    }
    
    var buttonImageName: String {
        switch (progress, lesson.isDownloading ) {
        case (1.0, _): return "checkmark.circle.fill"
        case (_, true): return "pause.fill"
        default: return "tray.and.arrow.down"
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

    private static let lessonViewModel = LessonsViewModelImpl(service: LessonsServiceImpl())

    static var previews: some View {
        LessonDetailsViewControllerView(lesson: lesson, lessonViewModel: lessonViewModel)
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
