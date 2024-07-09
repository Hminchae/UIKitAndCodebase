//
//  LoginViewModel.swift
//  SeSAC5MVVMBasic
//
//  Created by 황민채 on 7/9/24.
//

import Foundation
import UIKit

class LoginViewModel {
    
    // 실시간으로 달라지는 데이터를 감지 -> 그런데- 조금 숨겨보고싶다!
    var inputId: String? = "" {
        didSet {
            validation()
        }
    }
    
    var inputPassword: String? = ""{
        didSet {
            validation()
        }
    }
    
    var outputValidationText = ""
    var outputValid = false

    private func validation() {
        
        guard let id = inputId, let pw = inputPassword else {
            return
        }
        
        if id.count >= 3 && pw.count > 5 {
            print("유효성 통과")
            outputValid = true
            outputValidationText = "통과요~~"
        } else {
            print("유효성 못통과")
            outputValid = false
            outputValidationText = "통과X요~~"
        }
    }
}

