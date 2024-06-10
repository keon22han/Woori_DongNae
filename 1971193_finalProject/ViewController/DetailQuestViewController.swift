//
//  DetailQuestViewController.swift
//  1971193_finalProject
//
//  Created by 한건희 on 5/26/24.
//

import UIKit

class DetailQuestViewController: UIViewController, ScrollableViewController {
    private let userInfo: UserInfo
    let scrollUiView = UIScrollView()
    let uiView = UIView()
    
    var scrollView: UIScrollView {
        self.scrollUiView
    }
    
    init(userInfo: UserInfo) {
        self.userInfo = userInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        scrollUiView.translatesAutoresizingMaskIntoConstraints = false
        scrollUiView.backgroundColor = .clear
        scrollUiView.contentSize = CGSize(width: view.safeAreaLayoutGuide.layoutFrame.width, height: 150)
        
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
        
        let uiViewHeight = uiView.heightAnchor.constraint(equalToConstant: 150)
        uiViewHeight.priority = .defaultLow // 낮은 우선순위를 줌으로서 ScrollView의 높이에 의존하도록 한다.
        uiViewHeight.isActive = true
        
        let userImageView = UIImageView()
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userImageView.image = UIImage(named: "roopy")
        
        let userLabel = UITextField()
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.text = userInfo.nickName
        
        uiView.addSubview(userImageView)
        uiView.addSubview(userLabel)
        
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
