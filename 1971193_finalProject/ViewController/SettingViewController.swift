import UIKit

class SettingViewController: UIViewController {
    
    var currentUserInfo: UserInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // 현재 로그인한 사용자 정보 가져오기
        DBManager.instance.getCurrentUserInfo { currentUser in
            guard let currentUser = currentUser else {
                print("Failed to get current user info")
                return
            }
            self.currentUserInfo = currentUser
            
            // UI 업데이트
            DispatchQueue.main.async {
                self.setupUI()
            }
        }
    }
    
    func setupUI() {
        // Setting Label
        let settingLabel = UILabel()
        settingLabel.text = "Setting"
        settingLabel.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        settingLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(settingLabel)
        
        NSLayoutConstraint.activate([
            settingLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            settingLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        // User Info View
        let userInfoView = UIView()
        userInfoView.isUserInteractionEnabled = true
        userInfoView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        userInfoView.layer.cornerRadius = 10
        userInfoView.translatesAutoresizingMaskIntoConstraints = false
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(userInfoViewTapped))
        userInfoView.addGestureRecognizer(tapGesture)
        view.addSubview(userInfoView)
        
        NSLayoutConstraint.activate([
            userInfoView.topAnchor.constraint(equalTo: settingLabel.bottomAnchor, constant: 20),
            userInfoView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            userInfoView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            userInfoView.heightAnchor.constraint(equalToConstant: 80)
        ])
        
        // User Image
        let userImageView = UIImageView(image: currentUserInfo?.image)
        userImageView.contentMode = .scaleAspectFill
        userImageView.layer.cornerRadius = 30
        userImageView.layer.masksToBounds = true
        userImageView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.addSubview(userImageView)
        
        NSLayoutConstraint.activate([
            userImageView.leadingAnchor.constraint(equalTo: userInfoView.leadingAnchor, constant: 10),
            userImageView.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor),
            userImageView.widthAnchor.constraint(equalToConstant: 60),
            userImageView.heightAnchor.constraint(equalToConstant: 60)
        ])
        
        // User NickName Label
        let userNickNameLabel = UILabel()
        userNickNameLabel.text = currentUserInfo?.nickName
        userNickNameLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        userNickNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.addSubview(userNickNameLabel)
        
        NSLayoutConstraint.activate([
            userNickNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            userNickNameLabel.topAnchor.constraint(equalTo: userInfoView.topAnchor, constant: 20)
        ])
        
        // User Name Label
        let userNameLabel = UILabel()
        userNameLabel.text = currentUserInfo?.name
        userNameLabel.font = UIFont.systemFont(ofSize: 14)
        userNameLabel.textColor = .gray
        userNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.addSubview(userNameLabel)
        
        NSLayoutConstraint.activate([
            userNameLabel.leadingAnchor.constraint(equalTo: userImageView.trailingAnchor, constant: 10),
            userNameLabel.topAnchor.constraint(equalTo: userNickNameLabel.bottomAnchor, constant: 5)
        ])
        
        // Arrow Image
        let arrowImageView = UIImageView(image: UIImage(systemName: "chevron.right"))
        arrowImageView.contentMode = .scaleAspectFit
        arrowImageView.translatesAutoresizingMaskIntoConstraints = false
        userInfoView.addSubview(arrowImageView)
        
        NSLayoutConstraint.activate([
            arrowImageView.trailingAnchor.constraint(equalTo: userInfoView.trailingAnchor, constant: -10),
            arrowImageView.centerYAnchor.constraint(equalTo: userInfoView.centerYAnchor),
            arrowImageView.widthAnchor.constraint(equalToConstant: 20),
            arrowImageView.heightAnchor.constraint(equalToConstant: 20)
        ])
        
        // 소개 Label
        let introductionLabel = UILabel()
        introductionLabel.text = "소개:"
        introductionLabel.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        introductionLabel.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(introductionLabel)
        
        NSLayoutConstraint.activate([
            introductionLabel.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 20),
            introductionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20)
        ])
        
        // Introduction TextView
        let introductionTextView = UITextView()
        introductionTextView.text = currentUserInfo?.userDescription
        introductionTextView.font = UIFont.systemFont(ofSize: 14)
        introductionTextView.backgroundColor = .clear
        introductionTextView.isEditable = false
        introductionTextView.isScrollEnabled = false
        introductionTextView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(introductionTextView)
        
        NSLayoutConstraint.activate([
            introductionTextView.topAnchor.constraint(equalTo: introductionLabel.bottomAnchor, constant: 10),
            introductionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            introductionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20)
        ])
        
        // Log Out Button
        let logOutButton = UIButton(type: .system)
        logOutButton.setTitle("Log Out", for: .normal)
        logOutButton.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        logOutButton.backgroundColor = UIColor.orange
        logOutButton.tintColor = .white
        logOutButton.layer.cornerRadius = 10
        logOutButton.layer.shadowColor = UIColor.black.cgColor
        logOutButton.layer.shadowOpacity = 0.5
        logOutButton.layer.shadowOffset = CGSize(width: 0, height: 2)
        logOutButton.layer.shadowRadius = 4
        logOutButton.translatesAutoresizingMaskIntoConstraints = false
        logOutButton.addTarget(self, action: #selector(logOutButtonClicked), for: .touchUpInside)
        view.addSubview(logOutButton)
        
        NSLayoutConstraint.activate([
            logOutButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20),
            logOutButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logOutButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            logOutButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
  
    func updateUI(with userInfo: UserInfo) {
        if let userImageView = view.subviews.compactMap({ $0 as? UIImageView }).first,
           let userNameLabel = view.subviews.compactMap({ $0 as? UILabel }).first(where: { $0.text == "Hasan Mahmud" }) {
            userImageView.image = userInfo.image
            userNameLabel.text = userInfo.name
        }
    }
    
    @objc func logOutButtonClicked(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func userInfoViewTapped(_ sender : UITapGestureRecognizer) {
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
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: uiViewController.view.leadingAnchor, constant: 20),
            backgroundView.trailingAnchor.constraint(equalTo: uiViewController.view.trailingAnchor, constant: -20),
            backgroundView.topAnchor.constraint(equalTo: uiViewController.view.topAnchor, constant: 20),
            backgroundView.bottomAnchor.constraint(equalTo: uiViewController.view.bottomAnchor, constant: -20),
            blurredBackgroundView.leadingAnchor.constraint(equalTo: backgroundView.leadingAnchor),
            blurredBackgroundView.trailingAnchor.constraint(equalTo: backgroundView.trailingAnchor),
            blurredBackgroundView.topAnchor.constraint(equalTo: backgroundView.topAnchor),
            blurredBackgroundView.bottomAnchor.constraint(equalTo: backgroundView.bottomAnchor)
        ])
        
        present(uiViewController, animated: true)
    }
}
