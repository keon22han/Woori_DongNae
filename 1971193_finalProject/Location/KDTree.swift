
import Foundation
import CoreLocation

class KDTree {
    var point: CLLocation
    var left: KDTree?
    var right: KDTree?
    
    init(point: CLLocation) {
        self.point = point
    }
    
    func insert(point: CLLocation, depth: Int = 0) {
        let currentDimension = depth % 2
        if (currentDimension == 0 && point.coordinate.latitude < self.point.coordinate.latitude) ||
            (currentDimension != 0 && point.coordinate.longitude < self.point.coordinate.longitude) {
            if let left = left {
                left.insert(point: point, depth: depth + 1)
            } else {
                left = KDTree(point: point)
            }
        } else {
            if let right = right {
                right.insert(point: point, depth: depth + 1)
            } else {
                right = KDTree(point: point)
            }
        }
    }
    
    func searchNearest(point: CLLocation, best: (distance: Double, node: KDTree?) = (Double.infinity, nil), depth: Int = 0) -> (distance: Double, node: KDTree?) {
        let currentDimension = depth % 2
        var best = best
        
        let distance = self.point.distance(from: point)
        if distance < best.distance {
            best = (distance, self)
        }
        
        let nextBranch: KDTree?
        let oppositeBranch: KDTree?
        
        if (currentDimension == 0 && point.coordinate.latitude < self.point.coordinate.latitude) ||
            (currentDimension != 0 && point.coordinate.longitude < self.point.coordinate.longitude) {
            nextBranch = left
            oppositeBranch = right
        } else {
            nextBranch = right
            oppositeBranch = left
        }
        
        if let nextBranch = nextBranch {
            best = nextBranch.searchNearest(point: point, best: best, depth: depth + 1)
        }
        
        if let oppositeBranch = oppositeBranch {
            let dimensionDistance = currentDimension == 0
                ? abs(self.point.coordinate.latitude - point.coordinate.latitude)
                : abs(self.point.coordinate.longitude - point.coordinate.longitude)
            
            if dimensionDistance < best.distance {
                best = oppositeBranch.searchNearest(point: point, best: best, depth: depth + 1)
            }
        }
        
        return best
    }
}
