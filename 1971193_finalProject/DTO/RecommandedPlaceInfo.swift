//
//  QuestInfo.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/15/24.
//
import Foundation
import CoreLocation
import UIKit

class RecommandedPlaceInfo {
    var placeName: String
    var placeDescription: String
    var placeImage: UIImage
    var placeImageURL: String
    // todo : userID로 유저 정보 띄우기
    var uploadUserID: String
    var placeLatitude: Double
    var placeLongitude: Double
    
    init() {
        self.placeName = ""
        self.placeDescription = ""
        self.placeImage = UIImage(named: "roopy")!
        self.placeImageURL = ""
        self.uploadUserID = ""
        self.placeLatitude = 0.0
        self.placeLongitude = 0.0
    }
    init(testInt: Int) {
        self.placeName = "잔치 국수 집"
        self.placeDescription = ""
        self.placeImage = UIImage(named: "place1")!
        self.placeImageURL = ""
        self.uploadUserID = ""
        self.placeLatitude = 37.510102
        self.placeLongitude = 126.924616
    }
    init(testString: String) {
        self.placeName = "해커톤 개최 장소"
        self.placeDescription = ""
        self.placeImage = UIImage(named: "place2")!
        self.placeImageURL = ""
        self.uploadUserID = ""
        self.placeLatitude = 37.510111
        self.placeLongitude = 125.924602
    }
    
    init(placeName: String, placeImage: UIImage, placeImageURL: String, placeDescription: String, uploadUserID: String, placeLatitude: Double, placeLongitude: Double) {
        self.placeName = placeName
        self.placeDescription = placeDescription
        self.placeImage = placeImage
        self.placeImageURL = placeImageURL
        self.uploadUserID = uploadUserID
        self.placeLatitude = placeLatitude
        self.placeLongitude = placeLongitude
    }
}
