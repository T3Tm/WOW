//
//  ColorReturn.swift
//  WOW
//
//  Created by choejihun on 6/2/24.
// #색깔 넣었을 때 그냥 /255 해서 Color 객체를 반환해줌

import Foundation
import SwiftUI

class MyColor{
    static func Color(_ red: Int,_ green: Int, _ blue: Int) -> Color{
        return SwiftUI.Color(red: Double(red)/255,green: Double(green)/255, blue: Double(blue)/255)
    }
}
