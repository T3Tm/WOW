//
//  MainController.swift
//  WOW
//
//  Created by 최지훈 on 6/5/24.
//

import Foundation
import UIKit

import Firebase

class MainController: UIViewController,myProtocol{
    func dataSend(data: String) {//데이터 받았기에 여기서도 똑같이 getData() 실행해준다.
        getData()//리로드 실행
    }
    //옆에 controller에서 이어 받고 옴
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var thisMonthOutcome: UILabel!
    
    @IBOutlet weak var lastMonthOutcome: UILabel!
    var uid: String?
    
    let now = Date()
    var cal = Calendar.current
    let dateFormatter = DateFormatter()
    var components = DateComponents()
    var coreData: [String : Any]?
    var days: [String] = []
    var daysCountInMonth = 0 // 해당 월이 며칠까지 있는지
    var weekdayAdding = 0 // 시작일
    
    
    @IBOutlet weak var selectedMonth: UILabel!
    
    @IBAction func nextMonth(_ sender: UIButton) {
        components.month = components.month! + 1
        self.calculation()
        self.collectionView.reloadData()
        getData()
    }
    
    private func calculation(){
        let firstDayOfMonth = cal.date(from: components)
        
        let firstWeekday = cal.component(.weekday, from: firstDayOfMonth!) // 해당 수로 반환이 됩니다. 1은 일요일 ~ 7은 토요일
        
        daysCountInMonth = cal.range(of: .day, in: .month, for: firstDayOfMonth!)!.count //달에 일이 firstDayOfMonth달에는 며칠 있는지 확인
        weekdayAdding = 2 - firstWeekday//
        
        self.selectedMonth.text = dateFormatter.string(from: firstDayOfMonth!)
        self.days.removeAll()
        
        
        for day in weekdayAdding...daysCountInMonth {
            if day < 1 { // 1보다 작을 경우는 비워줘야 하기 때문에 빈 값을 넣어준다.
                self.days.append("")
            } else {
                self.days.append(String(day))
            }
        }
    }
    
    @IBAction func prevMonth(_ sender: UIButton) {
        components.month = components.month! - 1
        self.calculation()
        self.collectionView.reloadData()
        getData()
    }
    
    
    @IBAction func friendBtn(_ sender: UIButton) {
        //친구 Controller 불러내기
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "friend") as? friendController else {return}
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeScene(nextVC, animate: false)
    }
    
    
    @IBAction func settingBtn(_ sender: UIButton) {
        //설정창으로 가기
        guard let nextVC = self.storyboard?.instantiateViewController(identifier: "setting") as? settingController else {return}
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeScene(nextVC, animate: false)
    }
    
    override func viewDidLoad() {
        //일단 여기가 시작
        collectionView.delegate = self
        collectionView.dataSource = self
        
        
        dateFormatter.dateFormat = "MMMM" // 월 표시 포맷 설정
        components.year = cal.component(.year, from: now)
        components.month = cal.component(.month, from: now)
        components.day = 1
        self.calculation()
        //데이터 갖고 오기
        
        getData()
    }
    func getData(){
        //이번 달 소비
        //이전 현재 소비 금액 갖고 오기
        let db = Firestore.firestore()
        db.collection("outcome").getDocuments { query, error in
            guard error == nil else {return}
            //비어있다면
            for document in query!.documents{
                if document.documentID == self.uid!{//uid와 같다면
                    //여기서 해당 데이터들 다 갖고 오기
                    self.coreData = document.data()

                    let todayGetDataString = "\(self.components.year!)-\(self.components.month!)"
                    
                    let t = (self.coreData?[todayGetDataString] as? [String]) ?? []
                    //있으면 데이터 세팅해주면 되는 거고
                    var total: Int = 0
                    if t.count == 0{
                        self.coreData?[todayGetDataString] = [Any](repeating: "0", count: self.daysCountInMonth)//현재 달 수
                        
                        let userRef = db.collection("outcome").document(self.uid!)
                        userRef.updateData(self.coreData!)
                    }else{
                        for price in t{
                            total += Int(price)!
                        }
                    }
                    
                    self.thisMonthOutcome.text = "\(total) 원"
                    
                    return
                }
            }
            //없다면 여기서 데이터 새로 셋팅하고 넣어주기
            self.thisMonthOutcome.text = "0 원"
            
            
            
            let db = Firestore.firestore()
            let userRef = db.collection("outcome").document(self.uid!)
            let date = Date()
            
            let todayGetDataString = "\(self.components.year!)-\(self.components.month!)"
            
            
            let Array: [Any] = [String](repeating: "0", count: self.daysCountInMonth)//현재 달 수
            //0원으로 값 넣어놓기
            let userData = [
                todayGetDataString : Array
            ]
            self.coreData = userData
            userRef.setData(userData)
        }
    }
    
}

extension MainController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {//해당 주차의 count 갯수
        return days.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CalendarCell", for: indexPath) as? CalendarCell else {
            return CalendarCell()
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
        
        // 추가로 원하는 동작을 여기서 수행
        // 예: 다른 뷰로 이동, 팝업 표시, 데이터 로드 등
        
        
        // 클릭한 년도 월 일 구현 완료
        // 여기서는 모달로 연결 하는 것이 좋음
        guard let vc = storyboard?.instantiateViewController(withIdentifier: "MainDetailView") as? MainDetailViewController else {return}
        vc.modalPresentationStyle = .fullScreen
        vc.modalTransitionStyle = .coverVertical
        vc.month = "\(components.month!)"
        vc.day = "\(selectday)" // 날짜 넣어주기
        let weeksList = getWeek(Int(selectday)!)
        vc.moveData = weeksList
        vc.uid = uid!
        
        let data = coreData?["\(components.year!)-\(components.month!)"] as? [String]
        let dayPrice = data?[Int(selectday)!-1] //여기서 금액을 알려줌
        vc.outCome = dayPrice
        vc.year = "\(components.year!)"
        vc.coreData = self.coreData!
        vc.parentController = self
        present(vc, animated: true)
    }
    
    func getWeek(_ clickDay: Int) -> [String]{
        var ret: [String] = []
        let totalCnt = days.count
        var front = 0
        var back = 6
        
        while front < totalCnt{
            var left = -10
            var right = 40
            if days[front] != ""{//back만 갖고 데이터 판별하기
                left = Int(days[front])!
            }
            if days[min(back, days.count - 1)] != ""{
                right = Int(days[min(back, days.count - 1)])!
            }
            
            if left <= clickDay, clickDay <= right{
                //이 때가 맞으므로 현재 front인덱스부터 back인덱스까지 조지자
                for d_day in front...min(back, days.count - 1){
                    ret.append(days[d_day])
                }
                break
            }
            front+=7
            back+=7
        }
        if ret.count != 7{
            while ret.count != 7{
                ret.append("")
            }
        }
        return ret
    }
}

