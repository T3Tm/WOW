//
//  plusModal.swift
//  WOW
//
//  Created by 최지훈 on 6/17/24.
//

import Foundation
import UIKit
protocol myProtocol{
    func dataSend(data: String)
}
class plusModal: UIViewController{
    @IBOutlet weak var textField: UITextField!
    var delegate : myProtocol?
    
    @IBAction func BackBtn(_ sender: UIButton) {
        if let text = textField.text{
            delegate?.dataSend(data: text)
        }
        
        
        
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        //화면 뜨고
        print("화면 생성되었습니다.")
    }
}
