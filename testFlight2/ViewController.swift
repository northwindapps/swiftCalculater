//
//  ViewController.swift
//  testFlight2
//
//  Created by yujin on 2020/10/26.
//  Copyright © 2020 yujin. All rights reserved.
//

import UIKit
import calculationservice
class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let test = Execution().excecute(expression:"3+3")
        print("test",test)
        
    }


}

