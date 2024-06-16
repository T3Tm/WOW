//
//  friendController.swift
//  WOW
//
//  Created by 최지훈 on 6/6/24.
//

import Foundation
import UIKit
import FirebaseAuth

class friendController: UIViewController{
    
    @IBOutlet weak var textField: UITextField!
    
    
    
    @IBAction func homeBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "Main") as? MainController else {return}
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeScene(nextVC, animate: false)
    }
    
    
    @IBAction func settingBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "setting") as? settingController else {return}
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeScene(nextVC, animate: false)
    }
    
    override func viewDidLoad() {
        print("friend 화면으로 화면전환이 되었습니다.")

    }
    
    
}
