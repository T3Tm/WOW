//
//  Main.swift
//  WOW
//
//  Created by choejihun on 6/2/24.
//
// 로그인 화면
// Main 색깔 따로 빼두기
import SwiftUI

struct Main: View {
    @State private var id: String = "ID를 입력하여주세요"
    @State private var password: String = ""
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        VStack(spacing: 20) {
            
            Spacer().frame(height: 300)
            //상단으로부터 얼마나 떨어져 있을 것인지
            HStack {
                Spacer().frame(width:30)
                Text("ID")
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                Spacer()
                    .frame(width:80)
                TextField("", text: $id)
                    .foregroundColor(.white)
                    .padding()
                    
            }
            .frame(height: 60)
            .background(MyColor.Color(51,51,51))
            .cornerRadius(15)
            .padding(.horizontal, 20)
            
        HStack {
                Spacer().frame(width:30)
                Text("PASSWORD")
                    .foregroundColor(.white)
                    .padding(.leading, 10)
                Spacer()
                SecureField("", text: $password)
                    .foregroundColor(.white)
                    .padding()
            }
            .frame(height: 60)
            .background(MyColor.Color(51,51,51))
            .cornerRadius(15)
            .padding(.horizontal, 20)
            
            Spacer().frame(height: 50)
            
            Button{
                //액션
                login()
            } label:{
                Text("Login")
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(MyColor.Color(51,51,51))
                    .cornerRadius(5)
            }
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .padding(.horizontal, 50)
            .frame(height: 60)
            
            Spacer()
        }
    }
    
    func login() -> Void{
        print("현재 로그인한 ID : \(id)")
        print("현재 로그인한 Password : \(password)")
    }
}

#Preview {
    Main()
}
