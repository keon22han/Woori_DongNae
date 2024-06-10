//
//  MainViewController.swift
//  1971193_finalProject
//
//  Created by 한건희 on 5/12/24.
//

import UIKit

class MainViewController: UIViewController {
    var suggestedUserList: [UIStackView] = []
    var suggestedUserInfos: [UserInfo] = []
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        DBManager.instance.getUsers() { users in
            print(users!.count)
            if let users = users {
                for user in users {
                    self.suggestedUserInfos.append(user)
                }
                DispatchQueue.main.async{
                    self.settingUI()
                }
            }
        }
    }
    
    private func settingUI() {
        // ScrollView 생성 및 설정
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(scrollView)
        
        // ScrollView의 프레임 레이아웃 가이드 제약 설정
        NSLayoutConstraint.activate([
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
        
        // ContentView 생성 및 추가
        let contentView = UIView()
        contentView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(contentView)
        
        // ScrollView의 콘텐츠 레이아웃 가이드 제약 설정
        NSLayoutConstraint.activate([
            contentView.leadingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.contentLayoutGuide.trailingAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.contentLayoutGuide.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.contentLayoutGuide.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.frameLayoutGuide.widthAnchor), // 스크롤 방향 설정
            contentView.heightAnchor.constraint(equalToConstant: 1000) // 콘텐츠 높이 설정
        ])
        
        // Content View 안에 들어갈 SubView
        let topSuggestedFriendsImageView = UIImageView()
        topSuggestedFriendsImageView.layer.cornerRadius = 20
        topSuggestedFriendsImageView.layer.masksToBounds = true
        topSuggestedFriendsImageView.backgroundColor = .black
        topSuggestedFriendsImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topSuggestedFriendsImageView)
        
        NSLayoutConstraint.activate([
            topSuggestedFriendsImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            topSuggestedFriendsImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            topSuggestedFriendsImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            topSuggestedFriendsImageView.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        // 콘텐츠 뷰 상단 노출 광고등
        let topScrollView = UIScrollView()
        topScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topScrollView)
        
        NSLayoutConstraint.activate([
            topScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topScrollView.topAnchor.constraint(equalTo: topSuggestedFriendsImageView.bottomAnchor, constant: 20),
            topScrollView.heightAnchor.constraint(equalToConstant: 120)
        ])
        
        let topContentView = UIView()
        topContentView.translatesAutoresizingMaskIntoConstraints = false
        topScrollView.addSubview(topContentView)
    
        var previousUserViewOuter: UIStackView? = nil
        print(String(suggestedUserInfos.count))
        for i in 0..<suggestedUserInfos.count {
            let topContentUserViewOuter = UIStackView()
            topContentUserViewOuter.tag = i
            self.suggestedUserList.append(topContentUserViewOuter)
            topContentUserViewOuter.axis = .vertical
            topContentUserViewOuter.spacing = 10
            topContentUserViewOuter.alignment = .center
            topContentUserViewOuter.translatesAutoresizingMaskIntoConstraints = false
            topContentUserViewOuter.isLayoutMarginsRelativeArrangement = true
            topContentUserViewOuter.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            topContentUserViewOuter.isUserInteractionEnabled = true
            
            topContentView.addSubview(topContentUserViewOuter)
            
            
            let topContentUserImageView = UIImageView()
            topContentUserImageView.image = suggestedUserInfos[i].image
            topContentUserImageView.frame.size.width = 80
            topContentUserImageView.frame.size.width = 80
            topContentUserImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let topContentUserNameLabel = UILabel()
            topContentUserNameLabel.text = suggestedUserInfos[i].name
            topContentUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
            
            topContentUserViewOuter.addArrangedSubview(topContentUserImageView)
            topContentUserViewOuter.addArrangedSubview(topContentUserNameLabel)
            
            NSLayoutConstraint.activate([
                topContentUserViewOuter.topAnchor.constraint(equalTo: topContentView.topAnchor),
                topContentUserViewOuter.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor),
                topContentUserViewOuter.widthAnchor.constraint(equalToConstant: 100)
            ])
            
            if let previousUserViewOuter = previousUserViewOuter {
                topContentUserViewOuter.leadingAnchor.constraint(equalTo: previousUserViewOuter.trailingAnchor, constant: 10).isActive = true
            } else {
                topContentUserViewOuter.leadingAnchor.constraint(equalTo: topContentView.leadingAnchor, constant: 10).isActive = true
            }
            
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(topContentUserViewOuterTapped))
            topContentUserViewOuter.addGestureRecognizer(tapGesture)
            
            previousUserViewOuter = topContentUserViewOuter
        }
        
        NSLayoutConstraint.activate([
            topContentView.topAnchor.constraint(equalTo: topScrollView.contentLayoutGuide.topAnchor),
            topContentView.bottomAnchor.constraint(equalTo: topScrollView.contentLayoutGuide.bottomAnchor),
            topContentView.leadingAnchor.constraint(equalTo: topScrollView.contentLayoutGuide.leadingAnchor),
            topContentView.trailingAnchor.constraint(equalTo: topScrollView.contentLayoutGuide.trailingAnchor),
            topContentView.heightAnchor.constraint(equalTo: topScrollView.frameLayoutGuide.heightAnchor),
            topContentView.trailingAnchor.constraint(equalTo: previousUserViewOuter!.trailingAnchor, constant: 10)
        ])
    }
    
    @objc func topContentUserViewOuterTapped(_ sender: UITapGestureRecognizer) {
        
        let userInfo = suggestedUserInfos[sender.view?.tag as! Int]
        
        let uiViewController = UIViewController()
        let blurEffect = UIBlurEffect(style: .systemUltraThinMaterialLight)
        let backgroundView = UIView()
        backgroundView.layer.cornerRadius = 30
        backgroundView.layer.masksToBounds = true
        backgroundView.translatesAutoresizingMaskIntoConstraints = false
        uiViewController.view.addSubview(backgroundView)
        
        let blurredBackgroundView = UIVisualEffectView(effect: blurEffect)
        blurredBackgroundView.layer.cornerRadius = 30
        blurredBackgroundView.layer.masksToBounds = true
        blurredBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        backgroundView.addSubview(blurredBackgroundView)
        
        let cardUserImage = UIImageView()
        cardUserImage.translatesAutoresizingMaskIntoConstraints = false
        cardUserImage.layer.cornerRadius = 20
        cardUserImage.layer.masksToBounds = true
        cardUserImage.contentMode = .scaleAspectFill
        cardUserImage.image = userInfo.image
        blurredBackgroundView.contentView.addSubview(cardUserImage)
    
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: uiViewController.view.leadingAnchor, constant: 50),
            backgroundView.trailingAnchor.constraint(equalTo: uiViewController.view.trailingAnchor, constant: -50),
            backgroundView.topAnchor.constraint(equalTo: uiViewController.view.topAnchor, constant: 100),
            backgroundView.bottomAnchor.constraint(equalTo: uiViewController.view.bottomAnchor, constant: -100),
            blurredBackgroundView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurredBackgroundView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            blurredBackgroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurredBackgroundView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor),
            cardUserImage.centerXAnchor.constraint(equalTo: blurredBackgroundView.centerXAnchor),
            cardUserImage.topAnchor.constraint(equalTo: blurredBackgroundView.topAnchor, constant: 50),
            cardUserImage.widthAnchor.constraint(equalToConstant: 200),
            cardUserImage.heightAnchor.constraint(equalToConstant: 200)
        ])
        
        
        
        
        present(uiViewController, animated: true)
    }
}

