import UIKit

class LoginViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet weak var idTextField: UITextField!
    @IBOutlet weak var pwTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var signupButton: UIButton!
    
    let dbManager: DBManager = DBManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idTextField.delegate = self
        pwTextField.delegate = self
        
        NotificationCenter.default.addObserver(self,  selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        loginButton.addTarget(self, action: #selector(loginButtonClicked), for: .touchUpInside)
        signupButton.addTarget(self, action: #selector(signupButtonClicked), for: .touchUpInside)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
                    if view.frame.origin.y == 0 {
                        view.frame.origin.y -= keyboardSize.height / 2
                    }
                }
    }
    
    @objc func keyboardWillHide(_ notification: NSNotification) {
        if view.frame.origin.y != 0 {
                    view.frame.origin.y = 0
                }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc func loginButtonClicked(sender: UIButton!) {
        DBManager.instance.loginFirebase(email: idTextField.text!, password: pwTextField.text!) { success in
            if success {
                self.navigationController?.view.showToast(message: "로그인 성공!")
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewController(withIdentifier: "tabBarController") as! UITabBarController
                 self.navigationController?.pushViewController(tabBarController , animated: true)
                UserLocationManager.instance.checkUserDeviceLocationServiceAuthorization(viewController: self)
            }
            else {
                self.navigationController?.view.showToast(message: "로그인에 실패하였습니다.")
            }
            self.idTextField.text = ""
            self.pwTextField.text = ""
        }
    }
    
    @objc func signupButtonClicked(sender: UIButton!) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let signupViewController = storyboard.instantiateViewController(withIdentifier: "signupViewController") as! UIViewController
        self.navigationController?.pushViewController(signupViewController, animated: true)
    }
}

