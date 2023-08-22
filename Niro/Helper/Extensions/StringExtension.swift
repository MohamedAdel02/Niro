//
//  StringExtention.swift
//  Niro
//
//  Created by Mohamed Adel on 07/08/2023.
//

import Foundation


extension String {
    
    func isValidEmail() -> Bool {
        
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: self)
    }
    
    func getMonth() -> String {
        
        switch self {
        case "01":
            return "January"
        case "02":
            return "February"
        case "03":
            return "March"
        case "04":
            return "April"
        case "05":
            return "May"
        case "06":
            return "June"
        case "07":
            return "July"
        case "08":
            return "August"
        case "09":
            return "September"
        case "10":
            return "October"
        case "11":
            return "November"
        case "12":
            return "December"
        default:
            return ""
        }
        
    }

}
