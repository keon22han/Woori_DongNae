//
//  SettingViewController.swift
//  1971193_finalProject
//
//  Created by 한건희 on 5/12/24.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate {
    
    @IBOutlet weak var annotationLabel: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
        mapView.register(MKAnnotationView.self, forAnnotationViewWithReuseIdentifier: NSStringFromClass(MKAnnotationView.self))
        
        createPlaceAnnotations()
        mapView.showsUserLocation = true
        UserLocationManager.instance.requestLocation() { location in
            if let location = location {
                let regionRadius: CLLocationDistance = 100 // 반경 100m
                self.centerMapOnLocation(location: location, radius: regionRadius)
            }
        }
    }

    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        
        DispatchQueue.main.async {
            self.mapView.setRegion(coordinateRegion, animated: true)
        }
    }
    
    func createPlaceAnnotation(placeInfo: RecommandedPlaceInfo) {
        let annotation = CustomPointAnnotation()
        annotation.placeInfo = placeInfo
        annotation.title = placeInfo.placeName
        annotation.coordinate = CLLocationCoordinate2D(latitude: placeInfo.placeLatitude, longitude: placeInfo.placeLongitude)
        annotation.image = placeInfo.placeImage
        annotation.subtitle = placeInfo.placeDescription
        DBManager.instance.getUserInfo(userID: placeInfo.uploadUserID) { user in
            if let user = user as? UserInfo {
                annotation.userInfo = user
                DispatchQueue.main.async {
                    self.mapView.addAnnotation(annotation)
                }
            }
        }
    }
    
    func createPlaceAnnotations() {
        DBManager.instance.getPlaces() { places in
            if let places = places as? [RecommandedPlaceInfo] {
                for place in places {
                    DBManager.instance.getCurrentUserInfo() { currUserInfo in
                        if let currUserInfo = currUserInfo as? UserInfo {
                            let targetPlaces = FriendRecommender.instance.recommendPlaces(for: currUserInfo, from: places.shuffled(), maxDistance: 10.0, maxPlaces: 10)
                            
                            for targetPlace in targetPlaces {
                                self.createPlaceAnnotation(placeInfo: place)
                            }
                        }
                    }
                }
            }
        }
    }
    
    func mapView(_ mapView: MKMapView, didDeselect annotation: any MKAnnotation) {
        if let presentedViewController = self.presentedViewController, presentedViewController is BottomSheetViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        let anno : CustomPointAnnotation? = annotation as? CustomPointAnnotation
        if let presentedViewController = self.presentedViewController, presentedViewController is BottomSheetViewController {
            presentedViewController.dismiss(animated: true, completion: nil)
        }
        showBottomSheet(userInfo: anno!.userInfo, recommandedPlaceInfo: anno!.placeInfo)
    }
    
    // todo : mapView에 보여지는 annotation 설정
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        let annotationIdentifier = "annotation"
        var annotationView: MKAnnotationView

        if let dequeuedAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: annotationIdentifier) {
            annotationView = dequeuedAnnotationView
            annotationView.annotation = annotation
        } else {
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: annotationIdentifier)
            
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        }
        
        // test : 어노테이션 뷰에 이미지 설정
        if let annotation = annotation as? CustomPointAnnotation {
            let annotationImage : UIImage = annotation.image!
            annotationView.image = annotationImage.resized(to: CGSize(width: 50, height: 50))
        }
        return annotationView
    }
    
    public func showBottomSheet(userInfo: UserInfo, recommandedPlaceInfo: RecommandedPlaceInfo) {
        let bottomSheetViewController = BottomSheetViewController(isTouchPassable: true, contentViewController: DetailPlaceViewController(userInfo: userInfo, placeInfo: recommandedPlaceInfo))
        present(bottomSheetViewController, animated: true)
    }
}

extension UIImage {
    func resized(to size: CGSize) -> UIImage? {
        let renderer = UIGraphicsImageRenderer(size: size)
        return renderer.image { _ in
            self.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}

class CustomPointAnnotation : MKPointAnnotation {
    var userInfo : UserInfo
    var placeInfo : RecommandedPlaceInfo
    var image : UIImage?
    
    override init() {
        userInfo = UserInfo()
        placeInfo = RecommandedPlaceInfo()
        super.init()
    }
    
    init(initUserInfo: UserInfo, initPlaceInfo: RecommandedPlaceInfo) {
        userInfo = initUserInfo
        placeInfo = initPlaceInfo
        super.init()
    }
}

