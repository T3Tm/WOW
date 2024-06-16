//
//  LoginViewController1.swift
//  WOW
//
//  Created by 최지훈 on 6/5/24.
//

import Foundation
import UIKit

import FirebaseAuth
import FirebaseCore
import Firebase

class LoginViewController: UIViewController {
    @IBOutlet weak var idTextField: UITextField!
    
    @IBOutlet weak var passTextField: UITextField!
    
    @IBOutlet weak var validLabel: UILabel!
    weak var handle: AuthStateDidChangeListenerHandle?
    
    let idRegex: Regex = /[A-za-z]+\w*\@\w+\.\w+/
    let passRegex: Regex = /[A-Za-z0-9!_@$%^&+=]{6,20}/
    
    @IBOutlet weak var progressIndicator: UIActivityIndicatorView!
    @IBAction func LoginBtn(_ sender: UIButton) {//login 로직 실행
        progressIndicator.startAnimating()
        progressIndicator.isHidden = false
        guard validMatch() else {
            progressIndicator.stopAnimating()
            progressIndicator.isHidden = true
            return}
        
        let id = idTextField.text!
        let pass = passTextField.text!
        
        Auth.auth().signIn(withEmail: id, password: pass){[weak self] authResult, error in //여기가 화면 전환 되는 부분
            
            guard let selfs = authResult else {return}
            self?.progressIndicator.stopAnimating()
            self?.progressIndicator.isHidden = true
            guard (selfs.user) != nil else{
                self?.validLabel.text = "로그인 실패하였습니다."
                return
            }
            guard let nextVC = self?.storyboard?.instantiateViewController(withIdentifier: "Main") as? MainController else { return }
            nextVC.uid = selfs.user.uid
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeScene(nextVC, animate: false)
            
           
        }
    }
    @IBAction func registerBtn(_ sender: UIButton) {
        progressIndicator.startAnimating()
        progressIndicator.isHidden = false
        //회원 가입 로직
        guard validMatch() else {
            progressIndicator.stopAnimating()
            progressIndicator.isHidden = true
            return
        }
        let id = idTextField.text!
        let pass = passTextField.text!
        Auth.auth().createUser(withEmail: id, password: pass) { [weak self] authResult, error in // 여기가 회원가입 부분
            self?.progressIndicator.isHidden = true
            self?.progressIndicator.stopAnimating()
            //로그인 성공 했는지 보면 된다.
            guard let self = self else {
                //회원 가입 실패
                return
            }
            guard (authResult?.user) != nil else{
                self.validLabel.text = "이미 존재하는 이메일 입니다."
                return
            }
            
            self.validLabel.text = "회원가입에 성공하였습니다."
            let db = Firestore.firestore()
            let userRef = db.collection("users").document(id)
            
            let userData = [
                "email": id,
            ]
            
            userRef.setData(userData)
        }
    }

    
    func validMatch() -> Bool{
        guard let id = idTextField.text else {
            validLabel.text = "ID를 입력하세요."
            return false
        }//id
        guard let pass = passTextField.text else {
            validLabel.text = "Password를 입력하세요."
            return false
        }//id
        
        //id 형식 맞게 썻는지 판별
        guard let ret = try? idRegex.wholeMatch(in: id)?.output else{
            validLabel.text = "이메일 형식이 맞지 않습니다."
            return false
        }
        
        guard let ret = try? passRegex.wholeMatch(in: pass)?.output else {
            validLabel.text = "비밀번호는 6글자이상입니다."
            return false
        }
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        progressIndicator.isHidden = true // 가리기
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        handle = Auth.auth().addStateDidChangeListener { auth, user in
            let uid = user?.uid
            let email = user?.email
            let photoURL = user?.photoURL
        }//갖고 오기
    }
    
    
    override func viewWillDisappear(_ animated: Bool) {
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    
    
}
