//
//  MainController.swift
//  WOW
//
//  Created by 최지훈 on 6/5/24.
//

import Foundation
import UIKit

class MainController: UIViewController{//옆에 controller에서 이어 받고 옴
    var uid: String?
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    override func viewDidLoad() {
        //일단 여기가 시작
        
    }
    
    
}

extension MainController: UICollectionViewDataSource, UICollectionViewDelegate{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        
        return 10
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as? CalendarCell else {
                return UICollectionViewCell()
            }
                
            return cell
    }
    
    
}
