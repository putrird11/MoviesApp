//
//  LoginView.swift
//  MoviesApp
//
//  Created by PUTRI RAHMADEWI on 27/02/23.
//

import UIKit

class LoginView: UIViewController {
  
  @IBOutlet weak var txtPassword: UITextField!
  @IBOutlet weak var txtUsername: UITextField!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    //Hide Keyboard
    self.setupToHideKeyboardOnTapOnView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.isNavigationBarHidden = true
  }
  
  @IBAction func btnLogin(_ sender: UIButton) {
    UserDefaults.standard.set(txtUsername.text!, forKey: "username")
    if txtUsername.text!.isEmpty && txtPassword.text!.isEmpty{
      //Show Alert
      let alert = UIAlertController(title: "Failed Login", message: "Username or Password is Empty", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
    } else if txtUsername.text == "admin" && txtPassword.text == "admin"{
      if txtUsername.text! != "" {
        let controller = TableListView()
        self.navigationController?.pushViewController(controller, animated: true)
      }
    } else{
      let alert = UIAlertController(title: "Failed Login", message: "Username or Password is False", preferredStyle: .alert)
      alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
      self.present(alert, animated: true, completion: nil)
    }
  }
}
