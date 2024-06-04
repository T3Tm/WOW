//
//  LoginViewController1.swift
//  WOW
//
//  Created by 최지훈 on 6/5/24.
//

import Foundation
import UIKit

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    
    @IBAction func LoginBtn(_ sender: UIButton) {//login 로직 실행
        print("현재 로그인한 ID : \(idTextField.text!)")
        print("현재 로그인한 Password : \(passTextField.text!)")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
}
