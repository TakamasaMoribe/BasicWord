//
//  ResultViewController.swift
//  BasicWord
//
//  Created by 森部高昌 on 2020/04/30.
//  Copyright © 2020 森部高昌. All rights reserved.
//

import UIKit

class ResultViewController: UIViewController {
           
    @IBOutlet weak var correctPercentLabel: UILabel! //正解率表示用ラベル
    

    override func viewDidLoad() {
        super.viewDidLoad()

        //問題数の取得  QuestionDataManeger.sharedInstance.questionDataArray *******
        let questionCount = QuestionDataManeger.sharedInstance.questionDataArray.count
        
        //正解数の取得
        var correctCount:Int = 0
        //正解数を計算する  QuestionDataManeger.sharedInstance.questionDataArray ******
            for questionData in QuestionDataManeger.sharedInstance.questionDataArray {
                if questionData.isCorrect() {
                    correctCount += 1
            }

        }
        
        //正解率の計算
        let correctPercent:Float = (Float(correctCount)/Float(questionCount)) * 100
 
        //小数第一位まで計算して表示
        correctPercentLabel.text = String(format: "%.1f", correctPercent) + "%"
    }
    

}
