import UIKit
import CoreLocation

class MainViewController: UIViewController {
    var suggestedUserList: [UIView] = []
    var suggestedUserInfos: [UserInfo] = []
    var currentUserInfo: UserInfo?
    var recommendedPlaceInfos: [RecommandedPlaceInfo] = [] // RecommandedPlaceInfo 배열을 클래스 멤버 변수로 선언
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // TabBar의 투명도를 제거하고 배경색 설정
        if let tabBar = self.tabBarController?.tabBar {
            tabBar.isTranslucent = false
            tabBar.backgroundColor = .white
        }

        // 현재 로그인한 사용자 정보 가져오기
        DBManager.instance.getCurrentUserInfo { currentUser in
            guard let currentUser = currentUser else {
                print("Failed to get current user info")
                return
            }
            self.currentUserInfo = currentUser

            // 모든 사용자 정보 가져오기
            DBManager.instance.getUsers() { users in
                guard let users = users else {
                    print("Failed to get users")
                    return
                }

                // 모든 사용자 정보를 suggestedUserInfos에 저장
                self.suggestedUserInfos = users

//                // 본인을 기준으로 모든 사용자의 ktree 거리 계산
//                FriendRecommender.instance.buildTree(from: self.suggestedUserInfos, centeredOn: currentUser)
                // user 중 본인의 이름과 동일한 것을 제외하고 배열 불러오기 일일이 CLLocation의 거리 계산 로직 사용 중
                let recommendedFriends = FriendRecommender.instance.recommendFriends(for: currentUser, from: self.suggestedUserInfos.shuffled(), maxDistance: 1.0, maxFriends: 10)

                // recommendedFriends를 suggestedUserInfos로 업데이트
                self.suggestedUserInfos = recommendedFriends

                
                DBManager.instance.getPlaces() { places in
                    if let places = places as? [RecommandedPlaceInfo] {
                        let targetPlaces = FriendRecommender.instance.recommendPlaces(for: currentUser, from: places.shuffled(), maxDistance: 100.0, maxPlaces: 6)
                        // UI 업데이트
                        self.recommendedPlaceInfos = targetPlaces
                        DispatchQueue.main.async {
                            self.settingUI()
                        }
                    }
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

        let mainLabel = UILabel()
        mainLabel.translatesAutoresizingMaskIntoConstraints = false
        mainLabel.text = "Main"
        mainLabel.font = UIFont.systemFont(ofSize: 25, weight: .bold)
        mainLabel.textAlignment = .center
        contentView.addSubview(mainLabel)
        

        NSLayoutConstraint.activate([
            mainLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            mainLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  20),
            mainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -20),
            mainLabel.heightAnchor.constraint(equalToConstant: 30)
        ])

        let suggestedFriendLabel = UILabel()
        suggestedFriendLabel.translatesAutoresizingMaskIntoConstraints = false
        suggestedFriendLabel.text = "Suggested Friends"
        suggestedFriendLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        suggestedFriendLabel.textAlignment = .left
        contentView.addSubview(suggestedFriendLabel)
        

        NSLayoutConstraint.activate([
            suggestedFriendLabel.topAnchor.constraint(equalTo: mainLabel.bottomAnchor, constant: 20),
            suggestedFriendLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant:  20),
            suggestedFriendLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  -20),
            suggestedFriendLabel.heightAnchor.constraint(equalToConstant: 30)
        ])
        
        // 콘텐츠 뷰 상단 노출 광고등
        let topScrollView = UIScrollView()
        topScrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(topScrollView)

        NSLayoutConstraint.activate([
            topScrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            topScrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            topScrollView.topAnchor.constraint(equalTo: suggestedFriendLabel.bottomAnchor, constant: 20),
            topScrollView.heightAnchor.constraint(equalToConstant: 120)
        ])

        let topContentView = UIView()
        topContentView.translatesAutoresizingMaskIntoConstraints = false
        topScrollView.addSubview(topContentView)

        var previousUserViewOuter: UIView? = nil
        print(String(suggestedUserInfos.count))
        for i in 0..<suggestedUserInfos.count {
            let topContentUserViewOuter = UIView()
            topContentUserViewOuter.tag = i
            self.suggestedUserList.append(topContentUserViewOuter as! UIView)
            topContentUserViewOuter.translatesAutoresizingMaskIntoConstraints = false
            topContentUserViewOuter.layoutMargins = UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
            topContentUserViewOuter.contentMode = .scaleAspectFill
            topContentUserViewOuter.layer.masksToBounds = true
            topContentUserViewOuter.layer.cornerRadius = 5
            topContentUserViewOuter.layer.shadowColor = UIColor.black.cgColor
            topContentUserViewOuter.layer.shadowOpacity = 0.3
            topContentUserViewOuter.layer.shadowOffset = CGSize(width:2, height: 2)
            topContentUserViewOuter.layer.shadowRadius = 4
            topContentUserViewOuter.isUserInteractionEnabled = true

            topContentView.addSubview(topContentUserViewOuter)

            let topContentUserImageView = UIImageView()
            topContentUserImageView.image = suggestedUserInfos[i].image
            topContentUserImageView.translatesAutoresizingMaskIntoConstraints = false
            topContentUserImageView.layer.cornerRadius = 45
            topContentUserImageView.layer.masksToBounds = true
            topContentUserImageView.layer.shadowColor = UIColor.black.cgColor
            topContentUserImageView.layer.shadowOpacity = 0.3
            topContentUserImageView.layer.shadowOffset = CGSize(width: 2, height: 2)
            topContentUserImageView.layer.shadowRadius = 4
            topContentUserImageView.translatesAutoresizingMaskIntoConstraints = false
            topContentUserImageView.backgroundColor = .lightGray
            
            let topContentUserNameLabel = UILabel()
            topContentUserNameLabel.text = suggestedUserInfos[i].nickName
            topContentUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
            topContentUserNameLabel.textAlignment = .center

            topContentUserViewOuter.addSubview(topContentUserImageView)
            topContentUserViewOuter.addSubview(topContentUserNameLabel)

            NSLayoutConstraint.activate([
                topContentUserViewOuter.topAnchor.constraint(equalTo: topContentView.topAnchor),
                topContentUserViewOuter.bottomAnchor.constraint(equalTo: topContentView.bottomAnchor),
                topContentUserViewOuter.widthAnchor.constraint(equalToConstant: 100),
                topContentUserImageView.centerXAnchor.constraint(equalTo: topContentUserViewOuter.centerXAnchor),
                topContentUserImageView.topAnchor.constraint(equalTo: topContentUserViewOuter.topAnchor),
                topContentUserImageView.widthAnchor.constraint(equalToConstant: 90),
                topContentUserImageView.heightAnchor.constraint(equalToConstant: 90),
                topContentUserNameLabel.leadingAnchor.constraint(equalTo: topContentUserViewOuter.leadingAnchor),
                topContentUserNameLabel.trailingAnchor.constraint(equalTo: topContentUserViewOuter.trailingAnchor),
                topContentUserNameLabel.bottomAnchor.constraint(equalTo: topContentUserViewOuter.bottomAnchor)
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

        // "Nearest Location" 텍스트 추가
        let nearestLocationLabel = UILabel()
        nearestLocationLabel.text = "Nearest Location"
        nearestLocationLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        nearestLocationLabel.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(nearestLocationLabel)

        NSLayoutConstraint.activate([
            nearestLocationLabel.topAnchor.constraint(equalTo: topScrollView.bottomAnchor, constant: 20),
            nearestLocationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20)
        ])

        // 둥근 네모 박스 카드 8개 추가
        let cardContainerView = UIView()
        cardContainerView.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(cardContainerView)

        NSLayoutConstraint.activate([
            cardContainerView.topAnchor.constraint(equalTo: nearestLocationLabel.bottomAnchor, constant: 20),
            cardContainerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            cardContainerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            cardContainerView.heightAnchor.constraint(equalToConstant: 700) // 카드의 높이를 적절히 설정합니다.
        ])

        let numberOfRows = 3
        let numberOfColumns = 2
        let cardSpacing: CGFloat = 10.0
        let cardWidth = (UIScreen.main.bounds.width - 40 - (cardSpacing * CGFloat(numberOfColumns - 1))) / CGFloat(numberOfColumns)
        let cardHeight = cardWidth

        for row in 0..<numberOfRows {
            for column in 0..<numberOfColumns {
                let cardView = UIView()
                cardView.layer.cornerRadius = 10
                cardView.tag = row*numberOfColumns + column
                cardView.layer.masksToBounds = false
                cardView.layer.shadowColor = UIColor.black.cgColor
                cardView.layer.shadowOpacity = 0.3
                cardView.layer.shadowOffset = CGSize(width: 2, height: 2)
                cardView.layer.shadowRadius = 4
                cardView.translatesAutoresizingMaskIntoConstraints = false
                cardView.backgroundColor = .lightGray
                cardView.isUserInteractionEnabled = true
                
                cardContainerView.addSubview(cardView)

                let cardImageView = UIImageView()
                let cardLabel = UILabel()

                let cardIndex = row * numberOfColumns + column
                if cardIndex < recommendedPlaceInfos.count { // 배열에 있는 데이터만큼만 카드 추가
                    let place = recommendedPlaceInfos[cardIndex]

                    // 카드 안에 이미지 추가
                    cardImageView.image = place.placeImage // 배열에서 이미지 가져오기
                    cardLabel.text = place.placeName // 배열에서 텍스트 가져오기
                } else {
                    // 기본값 설정
                    cardImageView.image = nil
                    cardLabel.text = ""
                }

                cardImageView.contentMode = .scaleAspectFill
                cardImageView.layer.cornerRadius = 10
                cardImageView.tag = row*numberOfColumns + column
                cardImageView.layer.masksToBounds = true
                cardImageView.translatesAutoresizingMaskIntoConstraints = false
                cardImageView.isUserInteractionEnabled = true
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(cardViewTapped))
                cardImageView.addGestureRecognizer(tapGesture)
                cardView.addSubview(cardImageView)

                // 카드 안에 텍스트 추가
                cardLabel.textColor = .white
                cardLabel.font = UIFont.systemFont(ofSize: 14, weight: .bold)
                cardLabel.translatesAutoresizingMaskIntoConstraints = false
                cardView.addSubview(cardLabel)

                NSLayoutConstraint.activate([
                    cardView.widthAnchor.constraint(equalToConstant: cardWidth),
                    cardView.heightAnchor.constraint(equalToConstant: cardHeight),
                    cardView.leadingAnchor.constraint(equalTo: cardContainerView.leadingAnchor, constant: CGFloat(column) * (cardWidth + cardSpacing)),
                    cardView.topAnchor.constraint(equalTo: cardContainerView.topAnchor, constant: CGFloat(row) * (cardHeight + cardSpacing)),

                    cardImageView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor),
                    cardImageView.trailingAnchor.constraint(equalTo: cardView.trailingAnchor),
                    cardImageView.topAnchor.constraint(equalTo: cardView.topAnchor),
                    cardImageView.bottomAnchor.constraint(equalTo: cardView.bottomAnchor),

                    cardLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 8),
                    cardLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -8)
                ])
            }
        }
    }

    @objc func cardViewTapped(_ sender: UITapGestureRecognizer) {
        if let imageView = sender.view as? UIImageView {
            if imageView.image == nil {
                return
            }
            let placeInfo = recommendedPlaceInfos[sender.view?.tag as! Int]
            
            if let tabBarController = self.tabBarController {
                DispatchQueue.main.async {
                    tabBarController.selectedIndex = 1
                    for viewController in tabBarController.viewControllers! {
                        if let viewController = viewController as? MapViewController {
                            let location : CLLocation = CLLocation(latitude: self.recommendedPlaceInfos[imageView.tag].placeLatitude, longitude: self.recommendedPlaceInfos[imageView.tag].placeLongitude)
                            let regionRadius: CLLocationDistance = 100 // 반경 100m
                            
                            viewController.centerMapOnLocation(location: location, radius: regionRadius)
                            
                            DBManager.instance.getUserInfo(userID: self.recommendedPlaceInfos[imageView.tag].uploadUserID) { userInfo in
                                if let userInfo = userInfo as? UserInfo {
                                    DispatchQueue.main.async {
                                        viewController.showBottomSheet(userInfo: userInfo, recommandedPlaceInfo: placeInfo)
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
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
        
        let cardUserNameLabel = UILabel()
        cardUserNameLabel.text = userInfo.nickName
        cardUserNameLabel.textAlignment = .center
        cardUserNameLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        cardUserNameLabel.translatesAutoresizingMaskIntoConstraints = false
        blurredBackgroundView.contentView.addSubview(cardUserNameLabel)
        
        let cardUserDescriptionTextField = UITextField()
        cardUserDescriptionTextField.translatesAutoresizingMaskIntoConstraints = false
        cardUserDescriptionTextField.font = UIFont.systemFont(ofSize: 15)
        cardUserDescriptionTextField.text = userInfo.userDescription
        cardUserDescriptionTextField.textAlignment = .center
        blurredBackgroundView.contentView.addSubview(cardUserDescriptionTextField)

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
            cardUserImage.heightAnchor.constraint(equalToConstant: 200),
            cardUserNameLabel.centerXAnchor.constraint(equalTo: blurredBackgroundView.centerXAnchor),
            cardUserNameLabel.topAnchor.constraint(equalTo: cardUserImage.bottomAnchor, constant: 50),
            cardUserNameLabel.widthAnchor.constraint(equalToConstant: 200),
            cardUserNameLabel.heightAnchor.constraint(equalToConstant: 30),
            cardUserDescriptionTextField.centerXAnchor.constraint(equalTo: blurredBackgroundView.centerXAnchor),
            cardUserDescriptionTextField.topAnchor.constraint(equalTo: cardUserNameLabel.bottomAnchor, constant: 10),
            cardUserDescriptionTextField.widthAnchor.constraint(equalToConstant: 200),
            cardUserDescriptionTextField.heightAnchor.constraint(equalToConstant: 100),
        ])

        present(uiViewController, animated: true)
    }
}
