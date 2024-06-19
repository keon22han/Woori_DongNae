//
//  CustomTabBarController.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/15/24.
//

import UIKit
import CoreLocation

class CustomTabBarController: UITabBarController, UITabBarControllerDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
    }
    

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        if var viewController = viewController as? MapViewController {
            DBManager.instance.getCurrentUserInfo() { currUserInfo in
                if let currUserInfo = currUserInfo {
                    let location = CLLocation(latitude: currUserInfo.locationLatitude, longitude: currUserInfo.locationLongitude)
                    let regionRadius: CLLocationDistance = 1000 // 반경 1km
                    viewController.centerMapOnLocation(location: location, radius: regionRadius)
                    print("mapviewcontroller")
                }
            }
        }
        else if let viewController = viewController as? UploadLocationViewController {
            viewController.setOnCurrentLocation()
        }
        else if var viewController = viewController as? MainViewController {
            print("mainviewController")
        }
    }
}
