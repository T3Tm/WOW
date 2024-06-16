//
//  settingController.swift
//  WOW
//
//  Created by 최지훈 on 6/7/24.
//

import Foundation
import UIKit

class settingController: UIViewController{
    @IBAction func friendBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "friend") as? friendController else {return}
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeScene(nextVC, animate: false)
    }
    @IBAction func homeBtn(_ sender: UIButton) {
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "Main") as? MainController else {return}
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeScene(nextVC, animate: false)
    }
    override func viewDidLoad() {
        print("settings view 생성 완료")
    }
}
