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
    
    @IBOutlet weak var historyTextView: UITextView! //成績履歴表示用テキストビュー
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //問題数の取得
        let totalNumberOfQuestions = QuestionDataManager.sharedInstance.questionDataArray.count
        //正解数の取得
        let correctCount = QuestionDataManager.sharedInstance.correctCount
        //正解率の計算
        let correctPercent:Float = (Float(correctCount)/Float(totalNumberOfQuestions)) * 100
        //小数第一位まで計算して表示
        correctPercentLabel.text = String(format: "%.1f", correctPercent) + "%"
        //表示後　正解数(correctCount)をクリアしておく
        QuestionDataManager.sharedInstance.correctCount = 0
        
        showHistory()//成績履歴の表示
        
    }
    // end of  override func viewDidLoad()  --------------------------

    //成績履歴の表示（テキストビューに、日付時刻　ファイル名　正解率）
    func showHistory()  {
        
        historyTextView.text = "日付時刻"+"ファイル名"+"正解率"
        
        
    }
    
    
    //次画面に移る前の処理 -----------------------------------------------
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        //UserDefaultsStandardにいくつかの値を保存しておく
        let defaults = UserDefaults.standard
        let restartFlag:Bool = false //再開用フラグ
        let correctCount = 0         //正解数
        let nowQuestionNo = 1        //出題順
        defaults.set(restartFlag, forKey: "restartFlag")   //再開用フラグをfalseに戻しておく
        defaults.set(correctCount, forKey: "correctCount") //正解数を"correctCount" =0 に戻しておく
        defaults.set(nowQuestionNo, forKey: "nowQuestionNo")//出題順を"nowQuestionNo" =1 に戻しておく
    }
    // end of override func prepare(for segue -----------------------
    
}
