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
        // 지도 초기위치, 확대/축소 설정
        let initialLocation = CLLocation(latitude: 37.7749, longitude: -122.4194) // sanfrancisco
        let regionRadius: CLLocationDistance = 10000 // 반경 10km
        
        centerMapOnLocation(location: initialLocation, radius: regionRadius) // 추후 내 위치로 설정
        
        let annotation = CustomPointAnnotation()
        annotation.title = "San Francisco"
        annotation.coordinate = CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194)
        annotation.subtitle = "California, USA"
        let userInfo = UserInfo(name: "keon", nickName: "keon22han", image: UIImage(named:"roopy"), imageURL: "", location: CLLocation(latitude: 37.7749, longitude: -122.4194))
        
        annotation.userInfo = userInfo
        
        mapView.addAnnotation(annotation)
    }
    
    func centerMapOnLocation(location: CLLocation, radius: CLLocationDistance) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: radius, longitudinalMeters: radius)
        
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(_ mapView: MKMapView, didSelect annotation: any MKAnnotation) {
        let anno : CustomPointAnnotation? = annotation as? CustomPointAnnotation
        let bottomSheetViewController = BottomSheetViewController(isTouchPassable: true, contentViewController: DetailQuestViewController(userInfo: UserInfo(name: anno?.userInfo.name as? String, nickName: anno?.userInfo.nickName as? String, image: UIImage(named:"roopy"), imageURL: "", location: CLLocation(latitude: 37.7749, longitude: -122.4194))))
        present(bottomSheetViewController, animated: true)
        
        
    }
    
    // todo : mapView에 보여지는 annotation 설정
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard !(annotation is MKUserLocation) else {
            return nil
        }

        let annotationIdentifier = "testAnnotation"
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
        var image = UIImage(named: "roopy")
        image = image?.resized(to: CGSize(width: 50, height: 50))
        annotationView.image = image
        
        return annotationView
    }
    
    func makeUpOpenAiInformation(jsonData: Data) -> String {
        let jsonObject =  try! JSONSerialization.jsonObject(with: jsonData, options: []) as! [String: Any]
        return String(data: jsonData, encoding: .utf8)!
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
    
    override init() {
        userInfo = UserInfo()
        super.init()
    }
    
    init(initUserInfo: UserInfo) {
        userInfo = initUserInfo
        super.init()
    }
}

// 콘텐츠의 크기가 동적으로 늘어나야 하므로, SelfSizingTableView 구현
//  - 단, 최대 크기 정하여 일정 크기 이상 늘어나면 사이즈가 maxHeight로 고정되도록 구현
final class SelfSizingTableView: UITableView {
    private let maxHeight: CGFloat
    
    override var intrinsicContentSize: CGSize {
        CGSize(width: contentSize.width, height: min(contentSize.height, maxHeight))
    }
    
    init(maxHeight: CGFloat) {
        self.maxHeight = maxHeight
        super.init(frame: .zero, style: .grouped)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        invalidateIntrinsicContentSize()
    }
}

// ScrollableViewController: 클라이언트 코드에서 해당 프로토콜에 명시된 인터페이스에 접근
final class MyViewController: UIViewController, ScrollableViewController {
    private let label = UILabel()
    
    private let tableView = SelfSizingTableView(maxHeight: UIScreen.main.bounds.height * 0.4).then {
        $0.allowsSelection = false
        $0.backgroundColor = UIColor.clear
        $0.separatorStyle = .none
        $0.bounces = true
        $0.showsVerticalScrollIndicator = true
        $0.contentInset = .zero
        $0.indicatorStyle = .black
        $0.estimatedRowHeight = 34.0
        $0.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
    }
    
    var scrollView: UIScrollView {
        self.tableView
    }
        
    init() {
        super.init(nibName: nil, bundle: nil)
        
        label.text = "test"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false

        setUpView()
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    private func setUpView() {
        self.view.addSubview(label)
        self.view.addSubview(tableView)
        
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 10),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: 10),
            label.widthAnchor.constraint(equalToConstant: 100)
        ])
        
        tableView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        tableView.dataSource = self
    }
}

extension MyViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        0
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "cell\(indexPath.row)"
        return cell
    }
}

