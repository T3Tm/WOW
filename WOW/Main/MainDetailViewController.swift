//
//  MainDetailViewController.swift
//  WOW
//
//  Created by 최지훈 on 6/16/24.
//

import Foundation
import UIKit
import Firebase


class MainDetailViewController: UIViewController{
    
    @IBOutlet weak var tableView: UITableView!
    
    var days: [String] = []
    
    // 어느 장소 V 금액
    var outcomes: [String] = ["다이소 3000원","빽다방 5000원",
                              "당구장 10000원"]
    var parentController: myProtocol?
    
    //어떤 데이터가 들어왔었는지 확인
    var date: String?
    var month: String?
    var day: String? // 현재 클릭한 날짜
    var year: String?
    
    var outCome: String?
    var coreData: [String : Any]?
    
    @IBOutlet weak var nowClickDay: UILabel!
    
    var moveData: [String]?
    var uid: String?
    
    @IBOutlet weak var MonthLabel: UILabel!
    
    
    @IBOutlet weak var weekCollectionView: UICollectionView!
    
    @IBOutlet weak var outComeLabel: UILabel!
    override func viewDidLoad() {
        setMonthLabel()
        weekCollectionView.delegate = self
        weekCollectionView.dataSource = self
        
        tableView.dataSource = self
        
        nowClickDay.text = "\(day!)일"
        outComeLabel.text = "\(outCome!)"
        settingData()
    }
    
    func settingData(){
        guard let list = moveData else {return}
        days = list
    }
    
    
    func setMonthLabel(){
        guard let text = month else{return}
        MonthLabel.text = "\(text)월"
    }
    
    
    @IBAction func plus(_ sender: UIButton) {
        //모달 띄워서 추가하기
        guard let nextVC = self.storyboard?.instantiateViewController(withIdentifier: "plusModal") as? plusModal else {return}
        
        //3. SecondVC에서 선언해둔 delegate가 self. 즉 대신해서 처리할 부분이 FirstVC라는 것을 아래의 구문을 통해 선언
        nextVC.delegate = self
        nextVC.modalPresentationStyle = .formSheet
        nextVC.modalTransitionStyle = .coverVertical
        present(nextVC,animated: true)
    }
    @IBAction func backHome(_ sender: UIButton) {
        parentController?.dataSend(data: "")//
        self.dismiss(animated: true)//데이터 다시 불러오라는 것을
        
        //알려줘야 되지 않나
    }
}

extension MainDetailViewController:  UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as? weekCell else {
            return weekCell()
        }
        
        cell.dateLabel.text = days[indexPath.row]
        if indexPath.row % 7 == 0 { // 일요일
            cell.dateLabel.textColor = .red
        } else if indexPath.row % 7 == 6 { // 토요일
            cell.dateLabel.textColor = .blue
        } else { // 월요일 좋아(평일)
            cell.dateLabel.textColor = .black
        }
        cell.dateLabel.font = UIFont.boldSystemFont(ofSize: UIFont.labelFontSize)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let myBoundSize: CGFloat = collectionView.bounds.width
        
        let cellSize : CGFloat = myBoundSize / 9
        return CGSize(width: cellSize, height: cellSize)
    }
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedDay = indexPath.row
        let selectday = days[selectedDay]//현재 날
        //현재 선택된 날짜로 라벨 바꿔주기
        day = selectday
        nowClickDay.text = "\(selectday)일"//
        var t = coreData?["\(year!)-\(month!)"] as? [String]
        outComeLabel.text = t?[Int(selectday)! - 1]
        //바꾸고 데이터도 다시 갖고 와야함.
    }
    
}


extension MainDetailViewController: UITableViewDataSource{
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "tableCell", for: indexPath) as! weekCellTableViewCell
        cell.outcome.text = outcomes[indexPath.row]
        cell.outcome.translatesAutoresizingMaskIntoConstraints = false
        
        cell.outcome.leadingAnchor.constraint(equalTo: cell.leadingAnchor, constant: 15).isActive = true
        cell.outcome.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        return cell
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outcomes.count
    }
}


extension MainDetailViewController: myProtocol{
    func dataSend(data: String){
        outComeLabel.text = "\(Int(outComeLabel.text!)! + Int(data)!)"
        //그리고 해당 core데이터 부분을 건드려서 데이터 값 바꿔주면 된다.
        var t = coreData?["\(year!)-\(month!)"] as? [String]
        t?[Int(day!)! - 1] = outComeLabel.text!
        coreData?["\(year!)-\(month!)"] = t
        //해당 데이터로 덮어쓰기
        let db = Firestore.firestore()
        let userRef = db.collection("outcome").document(self.uid!)
        userRef.updateData(coreData!)//데이터 업데이트하기
    }
}
