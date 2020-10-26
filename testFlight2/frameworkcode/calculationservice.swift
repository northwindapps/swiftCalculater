//
//  calculation.swift
//  calculationframework
//
//  Created by yujin on 2020/10/26.
//  Copyright © 2020 yujin. All rights reserved.
//

import Foundation

class CalculationService{
    
    
    func REPLACE_WITH_CONSTANT(source:String)->(String){//sin(PI/4)
        var input = source
        input = input.replacingOccurrences(of: "pi", with: String(Double.pi))
        input = input.replacingOccurrences(of: "e", with: String(M_E))
        
        return input
    }
    
    
    func BRACKET_INDEX(source:String,bracketsize:Int)->(Int){
        
        var input = source//sin60,sqrt4,log
        
        
        
        input = input.replacingOccurrences(of: "(", with: " ( ")
        input = input.replacingOccurrences(of: ")", with: " ) ")//これで中は数字だけ
        
        let elements : [String] = input.split{$0 == " "}.map(String.init)
        
        
        var bracketcount = 0
        var calcuationstart = -1
        
        
        
        for i in 0..<elements.count {
            
            if elements[i] == "(" {
                bracketcount += 1
                
                
                //最深部だから次はカッコはない
                if bracketcount == bracketsize {
                    
                    calcuationstart = i + 1
                    
                    bracketcount += 1
                }
            }
            
        }
        
        return calcuationstart//if -1 then over
    }
    
    func NUMCHECK(source:String)->(String){
        
        let numonly = source.trimmingCharacters(in: CharacterSet(charactersIn: "-0123456789").inverted)
        return numonly
    }
    
    func CALCULATION_OPERATION(source:String)->(String){
        //1+3/4*
        
        //http://stackoverflow.com/questions/34540332/how-to-get-the-first-character-of-each-word-in-a-string
        let firstc = NUMCHECK(source: String(describing: source.first))
        let lastc = NUMCHECK(source: String(describing: source.last))
        
        
        
        if firstc != "" && lastc != ""{
            
            //("enter")
            
            var resultvalue = NSDecimalNumber(string: "0.0")
            
            var input = source
            
            
            input = input.replacingOccurrences(of: "--", with: "+")
            input = input.replacingOccurrences(of: "+", with: " ")
            input = input.replacingOccurrences(of: "/", with: " / ")
            input = input.replacingOccurrences(of: "-", with: " -")
            input = input.replacingOccurrences(of: "*", with: " * ")
            input = input.replacingOccurrences(of: "^", with: " ^ ")
            
            
            
            
            var elements : [String] = input.split{$0 == " "}.map(String.init)
            
            
            
            for i in 0..<elements.count {
                
                if (elements[i] == "^" && Double(elements[i-1]) != nil && Double(elements[i+1]) != nil) {
                    
                    if Double(elements[i+1]) == nil{
                        
                        elements[i+1] = "error"
                        
                        elements[i-1] = "nil"
                        elements[i] = "nil"
                        //error
                        
                    }
                    else{
                        
                        let a = Double(elements[i-1])
                        let b = Double(elements[i+1])
                        
                        var c = pow(a!, b!)
                        
                        c = c*100000
                        
                        c = round(c)/100000
                        
                        
                        elements[i+1] = String(describing: c)
                        
                        elements[i-1] = "nil"
                        elements[i] = "nil"
                        
                    }
                    
                }
            }
            
            elements = elements.filter{$0 != "nil"}
            
            
            for i in 0..<elements.count {
                
                
                if elements[i] == "*" && Double(elements[i-1]) != nil && Double(elements[i+1]) != nil {
                    //("*")
                    
                    let a = NSDecimalNumber(string: elements[i-1])
                    let b = NSDecimalNumber(string: elements[i+1])
                    
                    resultvalue = a.multiplying(by: b)
                    
                    elements[i+1] = String(describing: resultvalue)
                    
                    elements[i-1] = "nil"
                    elements[i] = "nil"
                    
                }
                
                if elements[i] == "/" && Double(elements[i-1]) != nil && Double(elements[i+1]) != nil{
                    
                    let a = NSDecimalNumber(string: elements[i-1])
                    let b = NSDecimalNumber(string: elements[i+1])
                    
                    if elements[i+1] == "0" {
                        
                        elements[i-1] = "nil"
                        elements[i] = "nil"
                        elements[i+1] = "nil"
                        
                    }
                    else{
                        
                        resultvalue = a.dividing(by: b)
                        
                        elements[i+1] = String(describing: resultvalue)
                        
                        elements[i-1] = "nil"
                        elements[i] = "nil"
                        
                    }
                }
                
                
            }
            
            
            elements = elements.filter{$0 != "nil"}
            
            
            //MUST NEED
            if elements.count > 1 {
                
                for i in 1..<elements.count {
                    
                    if Double(elements[i-1]) != nil && Double(elements[i]) != nil{
                        
                        let a = NSDecimalNumber(string: elements[i-1])
                        let b = NSDecimalNumber(string: elements[i])
                        
                        resultvalue = a.adding(b)
                        
                        elements[i] = String(describing: resultvalue)
                        
                        elements[i-1] = "nil"
                        
                        
                        
                        
                    }
                }
                
            }
            
            
            
            elements = elements.filter{$0 != "nil"}
            
            if elements.count == 1 {
                
                return elements[0]
            }
            else{
                
                return source
            }
            
        }
        else{
            
            //("didn't enter")
            return source
        }
        
    }
    
    
    
    func SCIENTIFIC_OPERATION(source:String)->(String){
        
        var resultvalue = NSDecimalNumber(string: "0.0")
        var input = source//sin60,sqrt4,log
        
        input = input.replacingOccurrences(of: "--", with: "+")
        input = input.replacingOccurrences(of: "+", with: " +")
        input = input.replacingOccurrences(of: "-", with: " -")
        
        input = input.replacingOccurrences(of: "/", with: " /")
        
        input = input.replacingOccurrences(of: "*", with: " *")
        
        
        input = input.replacingOccurrences(of: "^", with: " ^ ")
        
        
        
        
        input = input.replacingOccurrences(of: "sin", with: " sin")
        input = input.replacingOccurrences(of: "log", with: " log")
        input = input.replacingOccurrences(of: "cos", with: " cos")
        input = input.replacingOccurrences(of: "tan", with: " tan")
        input = input.replacingOccurrences(of: "sqr", with: " sqr")
        input = input.replacingOccurrences(of: "sin -", with: "sin-")
        input = input.replacingOccurrences(of: "cos -", with: "cos-")
        input = input.replacingOccurrences(of: "tan -", with: "tan-")
        input = input.replacingOccurrences(of: "a sin", with: "asin")
        input = input.replacingOccurrences(of: "a cos", with: "acos")
        input = input.replacingOccurrences(of: "a tan", with: "atan")
        
        
        
        input = input.replacingOccurrences(of: "(", with: " ( ")
        input = input.replacingOccurrences(of: ")", with: " ) ")
        
        
        
        
        var elements : [String] = input.split{$0 == " "}.map(String.init)
        
        //(elements)
        
        
        for i in 0..<elements.count {
            
            if elements[i].contains("asin") {
                
                if Double(elements[i].replacingOccurrences(of: "asin", with: "")) == nil{
                    
                    
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "asin", with: "")
                    
                    
                    //http://stackoverflow.com/questions/39890795/decimal-to-double-conversion-in-swift-3
                    resultvalue = NSDecimalNumber(value:asin(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                    
                }
                
            }
            
            if elements[i].contains("acos") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "acos", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "acos", with: "")
                    
                    //http://stackoverflow.com/questions/39890795/decimal-to-double-conversion-in-swift-3
                    resultvalue = NSDecimalNumber(value:acos(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            if elements[i].contains("atan") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "atan", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "atan", with: "")
                    
                    
                    //http://stackoverflow.com/questions/39890795/decimal-to-double-conversion-in-swift-3
                    resultvalue = NSDecimalNumber(value:atan(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            if elements[i].contains("sin") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "sin", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "sin", with: "")
                    
                    //http://stackoverflow.com/questions/39890795/decimal-to-double-conversion-in-swift-3
                    resultvalue = NSDecimalNumber(value:sin(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            if elements[i].contains("cos") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "cos", with: "")) == nil{
                    
                    //("cosnil")
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "cos", with: "")
                    
                    
                    //http://stackoverflow.com/questions/39890795/decimal-to-double-conversion-in-swift-3
                    resultvalue = NSDecimalNumber(value:cos(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            if elements[i].contains("tan") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "tan", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "tan", with: "")
                    
                    
                    //http://stackoverflow.com/questions/39890795/decimal-to-double-conversion-in-swift-3
                    resultvalue = NSDecimalNumber(value:tan(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            
            
            //
            if elements[i].contains("sqrt") {
                
                
                if Double(elements[i].replacingOccurrences(of: "sqrt", with: "")
                    ) == nil{
                    
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "sqrt", with: "")
                    
                    
                    //http://stackoverflow.com/questions/39890795/decimal-to-double-conversion-in-swift-3
                    resultvalue = NSDecimalNumber(value:sqrt(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            
            //http://swift.tecc0.com/?p=105
            if elements[i].contains("abs") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "abs", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "abs", with: "")
                    
                    resultvalue = NSDecimalNumber(value:fabs(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            
            
            if elements[i].contains("expb") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "expb", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "expb", with: "")
                    
                    resultvalue = NSDecimalNumber(value:exp2(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            if elements[i].contains("exp") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "exp", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "exp", with: "")
                    
                    resultvalue = NSDecimalNumber(value:exp(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            if elements[i].contains("logb") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "logb", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "logb", with: "")
                    
                    resultvalue = NSDecimalNumber(value:log2(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            
            if elements[i].contains("logd") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "logd", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "logd", with: "")
                    
                    resultvalue = NSDecimalNumber(value:log10(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            
            if elements[i].contains("log") {
                
                
                
                if Double(elements[i].replacingOccurrences(of: "log", with: "")) == nil{
                    
                }else{
                    
                    elements[i] = elements[i].replacingOccurrences(of: "log", with: "")
                    
                    resultvalue = NSDecimalNumber(value:log(Double(elements[i])!))
                    
                    elements[i] = String(describing: resultvalue)
                }
            }
            
            
            
        }
        
        //("elements")
        //(elements)
        
        let resultstr = elements.joined(separator: "")
        
        return resultstr
        
    }
    
    
    func BASIC_OPERATION(source:String)->(String){
        
        var resultvalue = NSDecimalNumber(string: "0.0")
        
        var input = source
        
        input = input.replacingOccurrences(of: "--", with: "+")
        input = input.replacingOccurrences(of: "+", with: " ")
        input = input.replacingOccurrences(of: "/", with: " / ")
        input = input.replacingOccurrences(of: "-", with: " -")
        input = input.replacingOccurrences(of: "*", with: " * ")
        input = input.replacingOccurrences(of: "^", with: " ^ ")
        
        var elements : [String] = input.split{$0 == " "}.map(String.init)
        
        
        
        for i in 0..<elements.count {
            
            if (elements[i] == "^" && Double(elements[i-1]) != nil && Double(elements[i+1]) != nil) {
                
                if Double(elements[i+1]) == nil{
                    
                    elements[i+1] = "error"
                    
                    elements[i-1] = "nil"
                    elements[i] = "nil"
                    //error
                    
                }
                else{
                    
                    let a = Double(elements[i-1])
                    let b = Double(elements[i+1])
                    
                    //let c = pow(a as Decimal, b!)
                    var c = pow(a!, b!)
                    
                    c = c*100000
                    
                    c = round(c)/100000
                    
                    
                    elements[i+1] = String(describing: c)
                    
                    elements[i-1] = "nil"
                    elements[i] = "nil"
                    
                }
                
            }
            
            
            if elements[i] == "*" && Double(elements[i-1]) != nil && Double(elements[i+1]) != nil {
                
                let a = NSDecimalNumber(string: elements[i-1])
                let b = NSDecimalNumber(string: elements[i+1])
                
                resultvalue = a.multiplying(by: b)
                
                elements[i+1] = String(describing: resultvalue)
                
                elements[i-1] = "nil"
                elements[i] = "nil"
                
            }
            
            if elements[i] == "/" && Double(elements[i-1]) != nil && Double(elements[i+1]) != nil{
                
                let a = NSDecimalNumber(string: elements[i-1])
                let b = NSDecimalNumber(string: elements[i+1])
                
                if elements[i+1] == "0" {
                    
                    elements[i-1] = "nil"
                    elements[i] = "nil"
                    elements[i+1] = "nil"
                    
                }
                else{
                    
                    resultvalue = a.dividing(by: b)
                    
                    elements[i+1] = String(describing: resultvalue)
                    
                    elements[i-1] = "nil"
                    elements[i] = "nil"
                    
                }
            }
            
            
        }
        
        
        elements = elements.filter{$0 != "nil"}
        
        
        //MUST NEED
        if elements.count > 1 {
            
            for i in 1..<elements.count {
                
                if Double(elements[i-1]) != nil && Double(elements[i]) != nil{
                    
                    let a = NSDecimalNumber(string: elements[i-1])
                    let b = NSDecimalNumber(string: elements[i])
                    
                    resultvalue = a.adding(b)
                    elements[i] = String(describing: resultvalue)
                    elements[i-1] = "nil"
 
                }
            }
            
        }

        elements = elements.filter{$0 != "nil"}
        
        let resultstr = elements.joined(separator: "")
        
        return resultstr
        
    }
    
    
    
}
