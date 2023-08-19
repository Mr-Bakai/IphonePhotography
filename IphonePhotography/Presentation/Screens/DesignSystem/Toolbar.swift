//
//  Toolbar.swift
//  IphonePhotography
//
//  Created by Bakai on 18/7/23.
//

import UIKit
import SnapKit

class UIToolbarView: BaseView {
    
    private let container = UIView()
    
    private let titleLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.textColor = .systemBlue
        return view
    }()
    
    private let backImage: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "chevron.backward")
        return imageView
    }()
    
    private let backImageContainer = UIView()
    
    private let downloadContainer = UIView()
    
    private let downloadButton = UIButton()
    
    private let downloadPlaceholder: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "cloud_download")?.withTintColor(.systemBlue)
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private let downloadLabel: UILabel = {
        let view = UILabel()
        view.font = UIFont.systemFont(ofSize: 16, weight: .regular)
        view.textColor = .systemBlue
        view.text = "Download"
        return view
    }()
    
    var backImageTapped: () -> () = {}
    
    init(title: String) {
        super.init(frame: .zero)
        self.titleLabel.text = title
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func addSubViews() {
        addSubview(container)
        container.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        container.addSubview(backImageContainer)
        backImageContainer.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview()
        }
        
        backImageContainer.addSubview(backImage)
        backImage.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(8)
        }
        
        container.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(backImageContainer.snp.trailing)
            make.centerY.equalToSuperview()
        }
        
        container.addSubview(downloadContainer)
        downloadContainer.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.centerY.equalToSuperview()
        }
        
        downloadContainer.addSubview(downloadLabel)
        downloadLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().offset(-6)
            make.centerY.equalToSuperview()
        }
        
        downloadContainer.addSubview(downloadPlaceholder)
        downloadPlaceholder.snp.makeConstraints { make in
            make.trailing.equalTo(downloadLabel.snp.leading).offset(-6)
            make.width.height.equalTo(20)
            make.centerY.equalToSuperview()
        }
        
        configureBtn()
        setupObservers()
    }
    
    private func configureBtn() {
        var config = UIButton.Configuration.plain()
        config.image = UIImage(named: "cloud_download")?.withTintColor(.systemBlue)
        config.imagePadding = 5
        config.title = "Download"
        config.imagePlacement = .leading
        config.preferredSymbolConfigurationForImage = UIImage.SymbolConfiguration(scale: .medium)
        
        config.titleTextAttributesTransformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.systemFont(ofSize: 16)
            return outgoing
        }
        
        downloadButton.configuration = config
    }

    override func setupUI() {}
    
    private func setupObservers() {
        let backImageTap = UITapGestureRecognizer(
            target: self,
            action: #selector(backImageTapped(tap:)))
        backImage.isUserInteractionEnabled = true
        backImage.addGestureRecognizer(backImageTap)
    }
    
    @objc func backImageTapped(tap: UITapGestureRecognizer) {
        backImageTapped()
    }
}


class BaseView: UIView {
    
    var isLoaded = false
    var isSetupConfig = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func layoutSubviews() {
        super.layoutSubviews()
        
        viewDidAppear()
        configure()
    }
    
    func viewDidAppear() {}
    
    private func configure() {
        if !isLoaded {
            isLoaded = true
            
            addSubViews()
            setupUI()
            onViewLoaded()
        }
    }
    
    open func onViewLoaded() {}
    
    open func addSubViews() {}
    
    open func setupUI() {}
}
