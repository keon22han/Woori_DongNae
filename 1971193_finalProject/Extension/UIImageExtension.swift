//
//  UIImageExtension.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/9/24.
//

import Foundation
import UIKit

extension UIImage {
    func applyBlurEffect() -> UIImage? {
        let context = CIContext(options: nil)
        guard let currentFilter = CIFilter(name: "CIGaussianBlur") else { return nil }
        let beginImage = CIImage(image: self)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        currentFilter.setValue(100, forKey: kCIInputRadiusKey) // 흐림의 강도
        
        guard let output = currentFilter.outputImage else { return nil }
        if let cgimg = context.createCGImage(output, from: output.extent) {
            let processedImage = UIImage(cgImage: cgimg)
            return processedImage
        }
        return nil
    }
}
