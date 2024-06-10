//
//  AuthManager.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/6/24.
//

import Foundation
import CoreLocation
import UIKit

class UserLocationManager: NSObject, CLLocationManagerDelegate {
    static let instance = UserLocationManager()
    let locationManager = CLLocationManager()
    var currentLocation: CLLocation?
    
    private var completion: ((CLLocation?) -> Void)?
    // weak var viewController: UIViewController?

    override init() {
        // self.viewController = viewController
        super.init()
        locationManager.delegate = self
    }
    
    public func checkUserDeviceLocationServiceAuthorization(viewController: UIViewController) {
        guard CLLocationManager.locationServicesEnabled() else {
             showRequestLocationServiceAlert(viewController: viewController)
            return
        }
        
        let authorizationStatus: CLAuthorizationStatus
        
        if #available(iOS 14.0, *) {
            authorizationStatus = locationManager.authorizationStatus
        } else {
            authorizationStatus = CLLocationManager.authorizationStatus()
        }
        
        // 문제 발생
         checkUserCurrentLocationAuthorization(authorizationStatus, viewController: viewController)
    }
    
    private func checkUserCurrentLocationAuthorization(_ status: CLAuthorizationStatus, viewController: UIViewController) {
        switch status {
        case .notDetermined:
            print("notDetermined")
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.requestWhenInUseAuthorization()
            
        case .denied, .restricted:
            print("denied or restricted")
            showRequestLocationServiceAlert(viewController: viewController)
            
        case .authorizedWhenInUse:
            print("authorizedWhenInUse")
            // 해결 필요
            locationManager.startUpdatingLocation()
            
        default:
            print("Default")
        }
    }
    
    private func showRequestLocationServiceAlert(viewController: UIViewController) {
        // guard let viewController = viewController else { return }

        let requestLocationServiceAlert = UIAlertController(title: "위치 정보 이용", message: "위치 서비스를 사용할 수 없습니다. \n디바이스의 '설정 > 개인정보 보호'에서 위치 서비스를 켜주세요.", preferredStyle: .alert)
        let goSetting = UIAlertAction(title: "설정으로 이동", style: .destructive) { _ in
            if let appSetting = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSetting)
            }
        }
        
        let cancel = UIAlertAction(title: "취소", style: .default) { [weak self] _ in
            DispatchQueue.main.async { self?.reloadData() }
        }
        requestLocationServiceAlert.addAction(cancel)
        requestLocationServiceAlert.addAction(goSetting)
        
        viewController.present(requestLocationServiceAlert, animated: true)
    }
    
    private func reloadData() {
        // 구현할 reloadData 메서드
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let coordinate = locations.last {
            self.currentLocation = coordinate
            print("latitude:", coordinate.coordinate.latitude)
            print("longitude:", coordinate.coordinate.longitude)
            self.completion?(coordinate)
        }
        self.completion = nil
        locationManager.stopUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(#function)
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkUserDeviceLocationServiceAuthorization(viewController: UIViewController())
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkUserDeviceLocationServiceAuthorization(viewController: UIViewController())
    }
    
    func requestLocation(completion: @escaping (CLLocation?) -> Void ) {
        locationManager.requestLocation()
        self.completion = completion
    }
}
