//
//  DetailQuestViewController.swift
//  1971193_finalProject
//
//  Created by 한건희 on 5/26/24.
//

import UIKit

class DetailPlaceViewController: UIViewController, ScrollableViewController {
    private let userInfo: UserInfo
    private let placeInfo: RecommandedPlaceInfo
    let scrollUiView = UIScrollView()
    let uiView = UIView()
    
    var scrollView: UIScrollView {
        self.scrollUiView
    }
    
    init(userInfo: UserInfo, placeInfo: RecommandedPlaceInfo) {
        self.userInfo = userInfo
        self.placeInfo = placeInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollUiView.translatesAutoresizingMaskIntoConstraints = false
        scrollUiView.backgroundColor = .clear
        scrollUiView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 400)
        
        uiView.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addSubview(scrollUiView)
        scrollUiView.addSubview(uiView)
        
        NSLayoutConstraint.activate([
            scrollUiView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollUiView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            scrollUiView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            scrollUiView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor)
        ])
        
        NSLayoutConstraint.activate([
            uiView.topAnchor.constraint(equalTo: scrollUiView.frameLayoutGuide.topAnchor, constant: 50),
            uiView.leadingAnchor.constraint(equalTo: scrollUiView.frameLayoutGuide.leadingAnchor),
            uiView.trailingAnchor.constraint(equalTo: scrollUiView.frameLayoutGuide.trailingAnchor),
            uiView.widthAnchor.constraint(equalTo: scrollUiView.widthAnchor)
        ])
        
        let uiViewHeight = uiView.heightAnchor.constraint(equalToConstant: 400)
        uiViewHeight.priority = .defaultLow // 낮은 우선순위를 줌으로서 ScrollView의 높이에 의존하도록 한다.
        uiViewHeight.isActive = true
        
        let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.image = userInfo.image
        
        let userLabel = UITextField()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.textAlignment = .center
        userLabel.text = userInfo.nickName
        
        let barView = UIView()
        barView.translatesAutoresizingMaskIntoConstraints = false
        barView.backgroundColor = .gray
        
        uiView.addSubview(userImageView)
        uiView.addSubview(userLabel)
        uiView.addSubview(barView)
        
        NSLayoutConstraint.activate([
            userImageView.centerXAnchor.constraint(equalTo: uiView.centerXAnchor),
            userImageView.topAnchor.constraint(equalTo: uiView.topAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 50),
            userImageView.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            userLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            userLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor),
            userLabel.widthAnchor.constraint(equalToConstant: 100),
            userLabel.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        NSLayoutConstraint.activate([
            barView.topAnchor.constraint(equalTo: userLabel.bottomAnchor, constant: 30),
            barView.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 10),
            barView.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -10),
            barView.heightAnchor.constraint(equalToConstant: 2)
        ])
        
        // 장소명, 장소 설명 view 담을 StackView 생성
        let placeOuter = UIStackView()
        placeOuter.setContentHuggingPriority(.defaultHigh, for: .vertical)
        placeOuter.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        placeOuter.axis = .vertical
        placeOuter.spacing = 15
        placeOuter.alignment = .center
        placeOuter.alignment = .fill
        placeOuter.distribution = .fill
        placeOuter.translatesAutoresizingMaskIntoConstraints = false
        
        uiView.addSubview(placeOuter)
        
        let placeNameOuter = UIStackView()
        placeNameOuter.backgroundColor = .systemGray
        placeNameOuter.layer.masksToBounds = true
        placeNameOuter.layer.cornerRadius = 10
        placeNameOuter.axis = .horizontal
        placeNameOuter.spacing = 10
        placeNameOuter.alignment = .fill
        placeNameOuter.distribution = .fill
        placeNameOuter.translatesAutoresizingMaskIntoConstraints = false
        
        placeOuter.addArrangedSubview(placeNameOuter)
        
        let placeNameLabel = UILabel()
        placeNameLabel.translatesAutoresizingMaskIntoConstraints = false
        placeNameLabel.text = "장소명"
        
        let placeNameTextView = UITextView()
        placeNameTextView.translatesAutoresizingMaskIntoConstraints = false
        placeNameTextView.font = UIFont.systemFont(ofSize: 15)
        placeNameTextView.text = self.placeInfo.placeName
        placeNameTextView.backgroundColor = .clear
        placeNameTextView.alignTextVerticallyInContainer()
        
        placeNameTextView.textAlignment = .center
        placeNameTextView.textColor = .black
        
        placeNameOuter.addArrangedSubview(placeNameLabel)
        placeNameOuter.addArrangedSubview(placeNameTextView)
        
        let placeDescriptionOuter = UIStackView()
        placeDescriptionOuter.backgroundColor = .systemGray
        placeDescriptionOuter.layer.masksToBounds = true
        placeDescriptionOuter.layer.cornerRadius = 10
        placeDescriptionOuter.setContentHuggingPriority(.defaultHigh, for: .vertical)
        placeDescriptionOuter.setContentCompressionResistancePriority(.defaultHigh, for: .vertical)
        placeDescriptionOuter.translatesAutoresizingMaskIntoConstraints = false
        placeDescriptionOuter.axis = .horizontal
        placeDescriptionOuter.alignment = .fill
        placeDescriptionOuter.distribution = .fill
        placeDescriptionOuter.spacing = 10
        
        placeOuter.addArrangedSubview(placeDescriptionOuter)
        
        let placeDescriptionLabel = UILabel()
        placeDescriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        placeDescriptionLabel.text = "장소 설명"
        
        let placeDescriptionTextView = UITextView()
        placeDescriptionTextView.translatesAutoresizingMaskIntoConstraints = false
        placeDescriptionTextView.textColor = .black
        placeDescriptionTextView.textAlignment = .center
        placeDescriptionTextView.font = UIFont.systemFont(ofSize: 15)
        placeDescriptionTextView.backgroundColor = .clear
        placeDescriptionTextView.text = self.placeInfo.placeDescription
        placeDescriptionTextView.alignTextVerticallyInContainer()
        
        placeDescriptionOuter.addArrangedSubview(placeDescriptionLabel)
        placeDescriptionOuter.addArrangedSubview(placeDescriptionTextView)
        
        NSLayoutConstraint.activate([
            placeOuter.topAnchor.constraint(equalTo: barView.bottomAnchor, constant: 10),
            placeOuter.leadingAnchor.constraint(equalTo: uiView.leadingAnchor, constant: 10),
            placeOuter.trailingAnchor.constraint(equalTo: uiView.trailingAnchor, constant: -10),
            placeOuter.heightAnchor.constraint(equalToConstant: 200),
            placeNameOuter.heightAnchor.constraint(equalToConstant: 30),
            placeDescriptionOuter.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension UIScrollView {
    override open var intrinsicContentSize: CGSize {
        CGSize(width: contentSize.width, height: contentSize.height)
    }
    
    override open func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}
