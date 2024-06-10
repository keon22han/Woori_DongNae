//
//  SignUpViewController.swift
//  1971193_finalProject
//
//  Created by 한건희 on 6/6/24.
//

import UIKit

class SignUpViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    
    @IBOutlet weak var signupDoneButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(capturePicture))
        self.userImageView.addGestureRecognizer(imageTapGesture)
        
        self.cancelButton.addTarget(self, action: #selector(cancelSignInButtonClicked), for: .touchUpInside)
        
        self.signupDoneButton.addTarget(self, action: #selector(signupDoneButtonClicked), for: .touchUpInside)
    }
    
    @objc func capturePicture(sender: UITapGestureRecognizer) {
        let albumAuthManager = AlbumAuthManager()
        albumAuthManager.presentPhotoLibrary(from: self)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let image = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        userImageView.image = image
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func cancelSignInButtonClicked(sender: UIButton!) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc func signupDoneButtonClicked(sender: UIButton!) {
        weak var sv: UIView!
        sv = SignUpViewController.displaySpinner(onView: self.view)
        UserLocationManager.instance.requestLocation { location in
            if let location = location {
                DBManager.instance.signUpFirebase(email: self.idTextField.text!, password: self.passwordTextField.text!, userInfo: UserInfo(name: self.nameTextField.text, nickName: self.nickNameTextField.text, image: self.userImageView.image, imageURL: "", location: location)) { success in
                    
                    sv.removeFromSuperview()
                    if success {
                        self.navigationController?.view.showToast(message: "회원가입 성공!", duration: 3.0)
                        self.navigationController?.popViewController(animated: true)
                        return
                    } else {
                        self.navigationController?.view.showToast(message: "중복된 아이디거나 빈칸이 있습니다", duration: 3.0)
                        return
                    }
                }
            }
            else {
                return
            }
        }
    }
}
