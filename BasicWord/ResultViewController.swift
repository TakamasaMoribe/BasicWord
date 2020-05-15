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
        
        //履歴データ全体
        var historyData:String = ""
        //１回分の履歴データ文字列
        var nowResult:String = ""//nowResult
        
        //現在の日付を取得
        let formatter = DateFormatter() //表示形式の指定
        formatter.dateStyle = .short    //短い表記
        formatter.timeStyle = .short    //短い表記
        formatter.locale = Locale(identifier: "ja_JP")//日本式
        let now = Date()          //現在の日時を取得
        var timeData:String = ""
        timeData = String(formatter.string(from:now))
        timeData = String(timeData.suffix(11))//後ろから11文字取り出す

        //ファイル名の取得・・・問題の種類を表す
        let singleton:Singleton = Singleton.sharedInstance
        let filename = singleton.getItem() //ファイル名を読み込む
        
        //正解率の取得
        var correctRate:String = "" //正解率
        correctRate = String(correctPercentLabel.text!)
        
        //１回分の履歴文字列をつくる
        nowResult = timeData + "    " + filename + "    " + correctRate
        
        //テキストビューに表示
        historyTextView.text = nowResult//１回分（今回の分だけ）の表示
        
        historyData = saveHistory(nowResult:nowResult)//過去の履歴を追加する
        
        historyTextView.text = historyData//全部の履歴の表示

        
    }
    // end of  func showHistory()  -----------------------------------

    
    //履歴を既存のファイルに保存する　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝履歴の消去もつくる
    func saveHistory(nowResult:String) -> String {
        
        //過去の履歴データファイルの読み込み　準備
        let thePath = NSHomeDirectory()+"/Documents/historyFile.txt"
        var tempText:String = "" //履歴データテキストを読み込む一時使用文字列
        var historyData:String = "" //履歴データを返す文字列
        
        //既存の履歴ファイルを読み込む。
        //ファイルマネージャーを使って、ファイルの有無を調べる
        let fileManager = FileManager.default

        guard (fileManager.fileExists(atPath: thePath)) else {
            //指定のファイルがなければ、新しくつくる
            let textData:String = ""
            do {
                try textData.write(toFile:thePath,atomically:true,encoding:String.Encoding.utf8)
            }catch {
            }
            return "ファイル作成に失敗"
        } //guard節ここまで
        
        //過去の履歴データファイル読込  tempTextとして取り出す
        do {
            let text = try String(contentsOfFile: thePath, encoding: String.Encoding.utf8)
            tempText = text//取り出したテキストデータをtempTextに入れる
            }catch let error as NSError {
            print("ファイル読み込みに失敗。\n \(error)")
        } //Do節ここまで
//print("historyData1:\(historyData)")//
        
tempText = ""//履歴の消去
       historyData = nowResult //今回の成績を履歴データに入れる
       historyData.append(tempText) //今回の成績に、過去の履歴(tempText)を追加する
        
        //履歴ファイルを保存する
        do {
            try historyData.write(toFile:thePath,atomically:true,encoding:String.Encoding.utf8)
        }catch {
        }
//print("historyData2:\(historyData)")

        return historyData//履歴ファイルに追加して返す
        
    }
    // end of  saveHistory(nowResult:String)  ------------------------

    
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
