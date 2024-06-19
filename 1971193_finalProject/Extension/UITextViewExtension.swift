//
//  UITextViewExtension.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/19/24.
//

import Foundation
import UIKit

extension UITextView {
    func alignTextVerticallyInContainer() {
        var topCorrect = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2
        topCorrect = topCorrect < 0.0 ? 0.0 : topCorrect;
        self.contentInset.top = topCorrect
    }
}
