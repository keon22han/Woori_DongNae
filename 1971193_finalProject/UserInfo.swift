//
//  UserInfo.swift
//  1971193_finalProject
//
//  Created by 한건희 on 5/15/24.
//

import Foundation
import CoreLocation
import UIKit

class UserInfo {
    var name : String
    var nickName : String
    var image: UIImage
    var imageURL: String?
    var locationLatitude: Double
    var locationLongitude: Double
    
    
    init() {
        self.name = ""
        self.nickName = ""
        self.image = UIImage(named: "roopy")!
        self.imageURL = ""
        let location: CLLocation = CLLocation(latitude: 0, longitude: 0)
        self.locationLatitude = location.coordinate.latitude
        self.locationLongitude = location.coordinate.longitude
    }
    
    
    init(name: String?, nickName: String?, image: UIImage?, imageURL: String?, location: CLLocation?) {
        self.name = name!
        self.nickName = nickName!
        self.image = image!
        self.imageURL = imageURL
        self.locationLatitude = location!.coordinate.latitude
        self.locationLongitude = location!.coordinate.longitude
    }
}
