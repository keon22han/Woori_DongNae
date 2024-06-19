
import Foundation
import CoreLocation

class FriendRecommender {
    static let instance = FriendRecommender()
    private init() {}
    var kdTree: KDTree?
    
    func buildTree(from users: [UserInfo], centeredOn centralUser: UserInfo) {
        // 모든 사용자 정보를 포함하는 리스트를 생성, 여기에는 centralUser가 포함됩니다.
        var allUsers = users
        if !allUsers.contains(where: { $0.name == centralUser.name }) {
            allUsers.append(centralUser)
        }

        // KDTree를 중심 사용자 위치를 기준으로 초기화
        kdTree = KDTree(point: CLLocation(latitude: centralUser.locationLatitude, longitude: centralUser.locationLongitude))

        // 모든 사용자를 KDTree에 삽입
        for user in allUsers {
            kdTree?.insert(point: CLLocation(latitude: user.locationLatitude, longitude: user.locationLongitude))
        }
    }

    
    func recommendFriends(for centralUser: UserInfo, from users: [UserInfo], maxDistance: Double, maxFriends: Int) -> [UserInfo] {
//        guard let kdTree = kdTree else { return [] }
        
        var recommendedFriends: [UserInfo] = []
        
        let centralLocation = CLLocation(latitude: centralUser.locationLatitude, longitude: centralUser.locationLongitude)
        
        for potentialFriend in users {
            if potentialFriend.name == centralUser.name {
                continue
            }
            
            let friendLocation = CLLocation(latitude: potentialFriend.locationLatitude, longitude: potentialFriend.locationLongitude)
            let distance = centralLocation.distance(from: friendLocation)
            if distance <= maxDistance * 1000 {
                recommendedFriends.append(potentialFriend)
                // 최대 친구 수를 초과하지 않도록 체크
                if recommendedFriends.count >= maxFriends {
                    break
                }
            }
        }
        
        return recommendedFriends
    }
    func recommendPlaces(for centralUser: UserInfo, from recommendedPlaceInfos: [RecommandedPlaceInfo], maxDistance: Double, maxPlaces: Int) -> [RecommandedPlaceInfo] {
//        guard let kdTree = kdTree else { return [] }
        
        var targetPlaces: [RecommandedPlaceInfo] = []
        
        let centralLocation = CLLocation(latitude: centralUser.locationLatitude, longitude: centralUser.locationLongitude)
        
        for place in recommendedPlaceInfos {
            
            let placeLocation = CLLocation(latitude: place.placeLatitude, longitude: place.placeLongitude)
            let distance = centralLocation.distance(from: placeLocation)
            if distance <= maxDistance * 1000 {
                targetPlaces.append(place)
                // 최대 장소 수를 초과하지 않도록 체크
                if targetPlaces.count >= maxPlaces {
                    break
                }
            }
        }
        
        return targetPlaces
    }

}
