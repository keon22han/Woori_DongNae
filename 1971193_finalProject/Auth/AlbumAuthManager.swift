//
//  AlbumAuthManager.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/6/24.
//

import Foundation
import Photos
import UIKit

class AlbumAuthManager {
    // 권한 상태 확인 및 권한 요청
        func checkPhotoLibraryAuthorization(completion: @escaping (Bool) -> Void) {
            let status = PHPhotoLibrary.authorizationStatus()
            
            switch status {
            case .authorized:
                // 사용자가 이미 권한을 허용한 상태
                completion(true)
                
            case .denied, .restricted:
                // 사용자가 권한을 거부했거나 접근이 제한된 상태
                completion(false)
                
            case .notDetermined:
                // 권한을 요청하지 않은 상태
                PHPhotoLibrary.requestAuthorization { newStatus in
                    DispatchQueue.main.async {
                        completion(newStatus == .authorized)
                    }
                }
                
            @unknown default:
                // 미래의 새로운 권한 상태에 대응하기 위한 처리
                completion(false)
            }
        }
        
        // 사진 앨범에서 이미지 선택
        func presentPhotoLibrary(from viewController: UIViewController) {
            checkPhotoLibraryAuthorization { authorized in
                if authorized {
                    let imagePickerController = UIImagePickerController()
                    imagePickerController.sourceType = .photoLibrary
                    imagePickerController.delegate = viewController as? (UIImagePickerControllerDelegate & UINavigationControllerDelegate)
                    viewController.present(imagePickerController, animated: true, completion: nil)
                } else {
                    self.showAuthorizationDeniedAlert(from: viewController)
                }
            }
        }
        
        // 권한 거부시 사용자에게 알림 표시
        private func showAuthorizationDeniedAlert(from viewController: UIViewController) {
            let alert = UIAlertController(title: "앨범 접근 권한 필요", message: "앨범 접근 권한이 거부되었습니다. 설정에서 권한을 허용해주세요.", preferredStyle: .alert)
            let goToSettingsAction = UIAlertAction(title: "설정으로 이동", style: .default) { _ in
                if let appSettingsURL = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettingsURL, options: [:], completionHandler: nil)
                }
            }
            let cancelAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
            alert.addAction(goToSettingsAction)
            alert.addAction(cancelAction)
            viewController.present(alert, animated: true, completion: nil)
        }
}
