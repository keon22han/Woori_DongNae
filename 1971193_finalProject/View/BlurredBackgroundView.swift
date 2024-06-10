//
//  BlurredBackgroundView.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/9/24.
//

import UIKit

class BlurredBackgroundView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupBlurEffect()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupBlurEffect()
    }
    
    private func setupBlurEffect() {
        let imageView = UIImageView(frame: bounds)
        imageView.contentMode = .scaleAspectFill
        imageView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        if let backgroundImage = UIImage(named: "background")?.applyBlurEffect() { // 적절한 이미지 이름으로 변경하세요
            imageView.image = backgroundImage
        }
        addSubview(imageView)
        sendSubviewToBack(imageView)
    }
}
