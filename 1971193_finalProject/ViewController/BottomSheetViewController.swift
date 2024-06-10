//
//  BottomSheetViewController.swift
//  1971193_finalProject
//
//  Created by 한건희 on 5/26/24.
//

import UIKit
import FloatingPanel
import Then
import SnapKit

protocol ScrollableViewController where Self: UIViewController {
    var scrollView: UIScrollView { get }
}

final class BottomSheetViewController: FloatingPanelController {
    private let isTouchPassable: Bool
    
    
    init(isTouchPassable: Bool, contentViewController: ScrollableViewController) {
        self.isTouchPassable = isTouchPassable
        super.init(delegate: nil)
        
        setUpView(contentViewController: contentViewController)
    }
    
    @available(*, unavailable)
    required init?(coder aDecoder: NSCoder) {
        fatalError()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    private func setUpView(contentViewController: ScrollableViewController) {
        // Contents
        set(contentViewController: contentViewController)
        track(scrollView: contentViewController.scrollView)
        
        // Appearance
        let appearance = SurfaceAppearance()
        appearance.cornerRadius = 16.0
        appearance.backgroundColor = .white
        appearance.borderColor = .clear
        appearance.borderWidth = 0
        
        surfaceView.grabberHandle.isHidden = false
        surfaceView.grabberHandle.backgroundColor = .gray
        surfaceView.grabberHandleSize = .init(width: 40, height: 4)
        surfaceView.appearance = appearance
        
        // Backdrop
        backdropView.dismissalTapGestureRecognizer.isEnabled = isTouchPassable ? false : true
        let backdropColor = isTouchPassable ? UIColor.clear : .black
        backdropView.backgroundColor = backdropColor
        
        // Layout
        // 아래에서 계속
        let layout = isTouchPassable ? TouchPassIntrinsicPanelLayout() : TouchBlockIntrinsicPanelLayout()
        self.layout = layout
        
        // delegate
        delegate = self // 아래에서 계속
    }
}

extension BottomSheetViewController: FloatingPanelControllerDelegate {
    func floatingPanelDidMove(_ fpc: FloatingPanelController) {
        let loc = fpc.surfaceLocation
        let minY = fpc.surfaceLocation(for: .full).y
        let maxY = fpc.surfaceLocation(for: .tip).y
        let y = isTouchPassable ? max(min(loc.y, minY), maxY) : min(max(loc.y, minY), maxY)
        fpc.surfaceLocation = CGPoint(x: loc.x, y: y)
    }
    
    // 특정 속도로 아래로 당겼을 때 dismiss 되도록 처리
    public func floatingPanelWillEndDragging(_ fpc: FloatingPanelController, withVelocity velocity: CGPoint, targetState: UnsafeMutablePointer<FloatingPanelState>) {
        guard velocity.y > 1000 else { return }
        dismiss(animated: true)
    }
}

final class TouchPassIntrinsicPanelLayout: FloatingPanelBottomLayout {
    override var initialState: FloatingPanelState { .tip }
    override var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .tip: FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0, referenceGuide: .safeArea)
        ]
    }
}

// TouchBlockIntrinsicPanelLayout.swift
final class TouchBlockIntrinsicPanelLayout: FloatingPanelBottomLayout {
    override var initialState: FloatingPanelState { .full }
    override var anchors: [FloatingPanelState : FloatingPanelLayoutAnchoring] {
        return [
            .full: FloatingPanelIntrinsicLayoutAnchor(fractionalOffset: 0, referenceGuide: .safeArea)
        ]
    }
    
    override func backdropAlpha(for state: FloatingPanelState) -> CGFloat {
        0.5
    }
}
