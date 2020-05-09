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

        //問題数の取得  QuestionDataManager.sharedInstance.questionDataArray *******
        let totalNumberOfQuestions = QuestionDataManager.sharedInstance.questionDataArray.count
        
        //正解数の取得
        let correctCount = QuestionDataManager.sharedInstance.correctCount
        
        //正解率の計算
        let correctPercent:Float = (Float(correctCount)/Float(totalNumberOfQuestions)) * 100
        //小数第一位まで計算して表示
        correctPercentLabel.text = String(format: "%.1f", correctPercent) + "%"
        
        //表示後　correctCountをクリアしておく
        QuestionDataManager.sharedInstance.correctCount = 0
        
        
    }
    
    //次画面に移る前の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
                //UserDefaultsStandardの参照
                let defaults = UserDefaults.standard      //UserDefaultsを参照する
                let restartFlag:Bool = false
                let correctCount = 0
                let nowQuestionNo = 1
                defaults.set(restartFlag, forKey: "restartFlag")   //再開用フラグをfalseに戻しておく
                defaults.set(correctCount, forKey: "correctCount") //正解数を"correctCount" =0 に戻しておく
                defaults.set(nowQuestionNo, forKey: "nowQuestionNo")//次の問題の出題順を"nowQuestionNo" =1 に戻しておく
        
    }
    
}
