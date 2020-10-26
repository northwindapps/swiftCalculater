//
//  execution.swift
//  calculationframework
//
//  Created by yujin on 2020/10/26.
//  Copyright © 2020 yujin. All rights reserved.
//

import Foundation

public class Execution{

    public init(){}
    
    public func excecute(expression:String)->String {
        var tempStr :String
        let CS = CalculationService()
        
        let charset = CharacterSet(charactersIn: "ABCDEFGHIJKLMNOPQRSTUVWXYZ")
        if expression.rangeOfCharacter(from: charset) == nil {
            tempStr = expression.replacingOccurrences(of: "=", with: "")
        }
            
        else{return "error"}
        
        //screening
        let firstChar = tempStr.suffix(1)
        if firstChar == "^"{
            
            return "error"
        }else if firstChar == "/"{
            
            return "error"
        }else if firstChar == "*"{
            
            return "error"
        }else if firstChar == "-"{
            
            return "error"
        }else if firstChar == "+"{
            
            return "error"
        }
        
        
        //Feb 9
        var elements = [String]()
        var bz_local = 0
        var startindex = -1
        
        var loopcounter = 10
        
        //PREPARATION
        tempStr = CS.REPLACE_WITH_CONSTANT(source: tempStr)
        
        //Comma Free
        tempStr = tempStr.replacingOccurrences(of: ",", with: "")
        
        if tempStr.contains("(") {
            
        }else{
            loopcounter = 0
            //no braces
            if Double(tempStr) == nil{
                tempStr = CS.SCIENTIFIC_OPERATION(source: tempStr)
                tempStr = CS.BASIC_OPERATION(source: tempStr)
            }
        }
        
        
        while loopcounter > 0  {
            
            
            tempStr = tempStr.replacingOccurrences(of: "(", with: " ( ")
            tempStr = tempStr.replacingOccurrences(of: ")", with: " ) ")//これで中は数字だけ
            
            elements = tempStr.split{$0 == " "}.map(String.init)
            bz_local = 0
            startindex = -1
            
            for i in 0..<elements.count {
                
                if elements[i] == "(" {
                    bz_local += 1
                }
            }
            
            while bz_local > 0 {
                
                startindex = CS.BRACKET_INDEX(source: tempStr, bracketsize:bz_local)
                elements[startindex] = CS.CALCULATION_OPERATION(source: elements[startindex])
                
                bz_local -= 1
            }
            
            
            if elements.count > 2 {//(9.5)->9.5
                
                for i in 2..<elements.count {
                    if elements[i] == ")" && elements[i-2] == "("{
                        elements[i] = "nil"
                        elements[i-2] = "nil"
                    }
                }
            }
            
            elements = elements.filter{$0 != "nil"}
            
            tempStr = elements.joined(separator: "")
            
            //ここでnext calculation (sin0.7853+1.75)、sin、sqrtを置換
            tempStr = CS.SCIENTIFIC_OPERATION(source: tempStr)
            
            if Double(tempStr) != nil{
                loopcounter = 0
            }
            loopcounter -= 1
        }
        
        if Double(tempStr) != nil{
            
            //http://swift-salaryman.com/round.php
            var calculated = Double(tempStr)! * 10000
            calculated = round(calculated) / 10000
            return String(calculated)
            
        }else{
            return "error"
        }
    }
    
}
