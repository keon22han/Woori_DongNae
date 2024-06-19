//
//  UploadLocationViewController.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/15/24.
//

import UIKit
import MapKit

class UploadLocationViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var locationUploadButton: UIButton!
    
    @IBOutlet weak var placeNameTextField: UITextField!
    
    @IBOutlet weak var placeDescriptionTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mapView.showsUserLocation = true
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(capturePicture))
        self.placeImageView.addGestureRecognizer(imageTapGesture)
        
        self.locationUploadButton.addTarget(self, action: #selector(uploadButtonClicked), for: .touchUpInside)
    }
    
    func setOnCurrentLocation() {
        UserLocationManager.instance.requestLocation() { location in
            if let location = location {
                let regionRadius: CLLocationDistance = 100 // 반경 100m
                self.centerMapOnLocation(location: location, radius: regionRadius)
            }
        }
    }
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @objc func capturePicture(sender: UITapGestureRecognizer) {
        let albumAuthManager = AlbumAuthManager()
        // 사진 촬영 가능하다면 촬영한 이미지로 올릴 수 있게 먼저 해야함.
        albumAuthManager.presentPhotoLibrary(from: self)
    }
    
    @objc func uploadButtonClicked(sender: UIButton!) {
        var placeInfo = RecommandedPlaceInfo()
        if placeNameTextField.text == "" || placeDescriptionTextField.text == "" {
            self.view.showToast(message: "작성하지 않은 칸이 존재합니다.", duration: 2.0)
            return
        }
        
        DBManager.instance.uploadPlaceInfo(placeImage: self.placeImageView.image!, placeName: self.placeNameTextField.text!, placeDescription: self.placeDescriptionTextField.text!) { success in
            if let success = success {
                print("success to upload recommanded place info")
            }
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        placeImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
}
