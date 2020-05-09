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

        //問題数の取得  QuestionDataManager.sharedInstance.questionDataArray ******* totalNumberOfQuestionsを直接読み込む　　変更の余地あり
        let totalNumberOfQuestions = QuestionDataManager.sharedInstance.questionDataArray.count
        
        //正解数の取得
        var correctCount:Int = 0
        correctCount = QuestionDataManager.sharedInstance.correctCount
//        //正解数を計算する  totalNumberOfQuestions.questionDataArray ******  変更の余地あり
//            for questionData in QuestionDataManager.sharedInstance.questionDataArray {
//                if questionData.isCorrect() {
//                    correctCount += 1
//            }
//        }

        
        
        //正解率の計算
        let correctPercent:Float = (Float(correctCount)/Float(totalNumberOfQuestions)) * 100
        //小数第一位まで計算して表示
        correctPercentLabel.text = String(format: "%.1f", correctPercent) + "%"
        
        let restartFlag:Bool = false                    //再開用フラグ
        let defaults = UserDefaults.standard      //UserDefaultsを参照する
        defaults.set(restartFlag, forKey: "restartFlag") //Flagをfalseに戻す
print("Result_restartFlag:\(restartFlag)")

        
    }
}
