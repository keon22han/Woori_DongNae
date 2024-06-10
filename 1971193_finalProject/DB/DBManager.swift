
import Foundation
import Firebase
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class DBManager {
    static let instance = DBManager()
    
    private func downloadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading image: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert data to image")
                completion(nil)
                return
            }
            completion(image)
        }
        task.resume()
    }
    
    private func downloadImages(from usersInfo: [UserInfo], completion: @escaping (Bool?) -> Void) {
        for idx in 0..<usersInfo.count {
            let imageURL = URL(string: usersInfo[idx].imageURL!)!
            self.downloadImage(from: imageURL) { image in
                if let userImage = image {
                    usersInfo[idx].image = userImage
                    if idx == usersInfo.count - 1 {
                        completion(true)
                    }
                } else {
                    print("Failed to download or convert image")
                }
            }
        }
    }
    
    public func signUpFirebase(email: String, password: String, userInfo: UserInfo, completion: @escaping (Bool) -> Void) {
        Auth.auth().createUser(withEmail: email, password: password) { (authresult, err) in
            let uid = authresult?.user.uid
            if let error = err {
                print("Error authentication: \(error.localizedDescription)")
                completion(false)
            }
            else {
                guard let imageData = userInfo.image.jpegData(compressionQuality: 0.5) else { return }
                let randomUUid = UUID().uuidString
                
                Storage.storage().reference().child("userImages").child("\(randomUUid).jpg").putData(imageData, metadata: nil) { (metadata, error) in
                    if let error = error {
                        print("Error uploading image: \(error.localizedDescription)")
                        completion(false)
                    } else {
                        print("Image uploaded successfully!")
                        Storage.storage().reference().child("userImages").child("\(randomUUid).jpg").downloadURL { (url, error) in
                            if let error = error {
                                print("Error getting download URL: \(error.localizedDescription)")
                                completion(false)
                            } else {
                                if let downloadURL = url {
                                    Database.database().reference().child("users").child(uid!).setValue(["name": userInfo.name, "profileImageUrl": "userInfo.profileImageUrl", "nickName": userInfo.nickName, "userImageURL": downloadURL.absoluteString, "locationLatitude": userInfo.locationLatitude, "locationLongitude": userInfo.locationLongitude]) { (authresult, err) in
                                        // test code
                                        print(err)
                                        completion(true)
                                    }
                                } else {
                                    completion(false)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    public func loginFirebase(email: String, password: String, completion: @escaping (Bool) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                completion(false)
            }

            if let authResult = authResult {
                completion(true)
            }
        }
    }
    
    public func getUsers(completion: @escaping ([UserInfo]?) -> Void) {
        
        var usersInfo = [UserInfo]()
        
        let userRef = Database.database().reference().child("users")
        userRef.observeSingleEvent(of: .value) { snapshot in
            guard let usersSnapshot = snapshot.children.allObjects as? [DataSnapshot] else {
                print("Failed to get users snapshot")
                completion([])
                return
            }
            for userSnapshot in usersSnapshot {
                guard let userData = userSnapshot.value as? [String: Any] else {
                    print("Failed to get user data")
                    continue
                }
                var userInfo = UserInfo()
                // 사용자 정보에서 필드 확인
                for (key, value) in userData {
                    switch key {
                    case "name":
                        userInfo.name = value as! String
                    case "nickName":
                        print("nickName: " , value as! String)
                        userInfo.nickName = value as! String
                    case "userImageURL" :
                        print(value as! String)
                        userInfo.imageURL = value as! String
                        
                    case "locationLatitude" :
                        if let latitude = value as? Double {
                            userInfo.locationLatitude = latitude
                        }
                        
                    case "locationLongitude" :
                        if let longitude = value as? Double {
                            userInfo.locationLongitude = longitude
                        }
                        
                    default:
                        print("..")
                    }
                }
                usersInfo.append(userInfo)
            }
            
            self.downloadImages(from: usersInfo) { success in
                if let success = success {
                    completion(usersInfo)
                }
            }
        }
    }
}
