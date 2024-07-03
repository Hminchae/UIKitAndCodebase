//
//  Enums.swift
//  Reminder
//
//  Created by 황민채 on 7/3/24.
//

import UIKit

enum View {
    enum NewREList: String, CaseIterable {
        case dueDate = "마감일"
        case tag = "태그"
        case priority = "우선순위"
        case addImage = "이미지 추가"
    }
    
    enum MainCategory: String, CaseIterable {
        case today = "오늘"
        case completed = "완료됨"
        case expacted = "예정"
        case all = "전체"
        
        var icon: String {
            switch self {
            case .today:
                return "megaphone.fill"
            case .completed:
                return "checkmark"
            case .expacted:
                return "calendar"
            case .all:
                return "tray.fill"
            }
        }
        
        var iconColor: UIColor {
            switch self {
            case .today:
                return UIColor.systemBlue
            case .completed:
                return UIColor.systemGray2
            case .expacted:
                return UIColor.systemRed
            case .all:
                return UIColor.systemGray4
            }
        }
    }
}
