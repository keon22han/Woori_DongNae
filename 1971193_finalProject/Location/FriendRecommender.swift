
import Foundation
import CoreLocation

class FriendRecommender {
    var kdTree: KDTree?
    
    func buildTree(from users: [UserInfo]) {
        guard let firstUser = users.first else { return }
        kdTree = KDTree(point: CLLocation(latitude: firstUser.locationLatitude, longitude: firstUser.locationLongitude))
        for user in users.dropFirst() {
            kdTree?.insert(point: CLLocation(latitude: user.locationLatitude, longitude: user.locationLongitude))
        }
    }
    
    func recommendFriends(for user: UserInfo, from users: [UserInfo], maxDistance: Double) -> [UserInfo] {
        guard let kdTree = kdTree else { return [] }
        
        var recommendedFriends: [UserInfo] = []
        
        for potentialFriend in users {
            if potentialFriend.name != user.name {
                let nearest = kdTree.searchNearest(point: CLLocation(latitude: potentialFriend.locationLatitude, longitude: potentialFriend.locationLongitude))
                if let nearestNode = nearest.node, nearest.distance <= maxDistance * 1000 {
                    recommendedFriends.append(potentialFriend)
                }
            }
        }
        return recommendedFriends
    }
}
