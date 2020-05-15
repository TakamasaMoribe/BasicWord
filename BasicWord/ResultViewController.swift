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

    //成績履歴の表示（テキストビューに、日付時刻　ファイル名　正解率）＝＝＝＝＝＝＝＝
    func showHistory()  {
        //１回分の履歴データ文字列
        var historyStr:String = ""
        
        //現在の日付を取得
        let formatter = DateFormatter() //表示形式の指定
        formatter.dateStyle = .short    //短い表記
        formatter.timeStyle = .short    //短い表記
        formatter.locale = Locale(identifier: "ja_JP")//日本式
        let now = Date()          //現在の日時を取得
        var timeData:String = ""
        timeData = String(formatter.string(from:now))
        timeData = String(timeData.suffix(11))//後ろから11文字取り出す

        //ファイル名の取得
        let singleton:Singleton = Singleton.sharedInstance
        let filename = singleton.getItem() //ファイル名を読み込む
        
        //正解率の取得
        var correctRate:String = "" //正解率
        correctRate = String(correctPercentLabel.text!)
        
        //１回分の履歴文字列をつくる
        historyStr = timeData + "    " + filename + "    " + correctRate
        
        //テキストビューに表示
        historyTextView.text = historyStr
    }
    // end of  func showHistory()  -----------------------------------

    
    //履歴を既存のファイルに保存する　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    func saveHistory(histryStr:String)  {
        
        var histryData:String = "" //履歴データを入れる文字列の初期化
        
        //既存の履歴ファイルを読み込む。まだなければ新しくつくる
        
        //データの読み込み　準備
        let thePath = NSHomeDirectory()+"/Documents/historyFile.txt"

            do {
                let histryData = try String(contentsOfFile: thePath, encoding: String.Encoding.utf8)


                }catch let error as NSError {
                     print("ファイル読み込みに失敗。\n \(error)")
            } //Do節ここまで
        
        //今回の履歴を追加する
        histryData.append(histryStr)//今回の履歴を追加
        //履歴ファイルを保存する
        
        
        
        
    }
    // end of  saveHistory(histryStr:String)  ------------------------

    
    //次画面に移る前の処理 （セグエを利用して、スタート画面に戻る）＝＝＝＝＝＝＝＝＝
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
