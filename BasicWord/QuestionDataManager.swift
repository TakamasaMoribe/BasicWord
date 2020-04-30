//
//  QuestionDataManager.swift
//  BasicWord
//
//  Created by 森部高昌 on 2020/04/30.
//  Copyright © 2020 森部高昌. All rights reserved.
//

import UIKit

//１つの問題に関する情報
class QuestionData {
    
    var questionNo:String     //問題番号 固有の番号　ｃｓｖファイルに記載されている
    var question:String       //問題文
    var correctAnswer:String  //正解
    var answer1:String        //選択肢１
    var answer2:String        //選択肢２
    var answer3:String        //選択肢３
    var answer4:String        //選択肢４
    
    var userChoiceAnswer:String = "" //ユーザーが選択した答
    
    init(questionSourceDataArray:[String]) {
        questionNo = questionSourceDataArray[0]    //問題番号
        question = questionSourceDataArray[1]      //問題文
        correctAnswer = questionSourceDataArray[2] //正解
        answer1 = questionSourceDataArray[3]       //選択肢１
        answer2 = questionSourceDataArray[4]       //選択肢２
        answer3 = questionSourceDataArray[5]       //選択肢３
        answer4 = questionSourceDataArray[6]       //選択肢４
    }
    
    //正誤の判定をして、Bool値を返す
    func isCorrect() -> Bool {
        if correctAnswer == userChoiceAnswer {
            return true
        }
        return false
    }
    
}
// end of class QuestionData =============================================

class QuestionDataManeger {
        
    var filename:String = ""  //問題ファイルの名前
    
    //シングルトン  sharedInstance = QuestionDataManeger() ******
    static let sharedInstance = QuestionDataManeger()
    
    //問題を格納するための配列
    var questionDataArray = [QuestionData]()
    
    //現在の問題のインデックス
    var nowQuestionIndex:Int = 0
    //シングルトンであることを保証するため
    private init(){
    }

    //問題の読み込み　QuestionDataManeger.sharedInstance.loadQuestion() ****
    func loadQuestion()  {
        questionDataArray.removeAll() //古いデータ配列を消去しておく
        nowQuestionIndex = 0          //インデックスも初期化
        let singleton:Singleton = Singleton.sharedInstance//ファイル名用のシングルトン******
        let filename = singleton.getItem() //ファイル名をシングルトンから読み込む
        
        //問題ファイルのパスを指定する　セクメンティッドコントロールから取得する
        guard let csvFilePath = Bundle.main.path(forResource: filename, ofType: "csv") else {
            print("ファイルが存在しません")//エラー処理が欲しい
            
            return
        }
        //問題ファイルからデータを読み込む
        //クロージャ:関数の実行結果を次の処理で続けて使用する関数
        //enumerateLinesは改行（\n (バックスラッシュ + n))単位で文字列を読み込むメソッド
        //stopはそのままの意味でstop変数にtrueを代入した時にループが終了する
        //lineやstopは決められた名前ではなく、自分の好きな名前を付けられる
        do {
            let csvStringData = try String(contentsOfFile: csvFilePath,encoding: String.Encoding.utf8)
            csvStringData.enumerateLines(invoking: {(line,stop) in //改行されるごとに分割する
                let questionSourceDataArray = line.components(separatedBy: ",") //１行を","で分割して配列に入れる
                let questionData = QuestionData(questionSourceDataArray: questionSourceDataArray)//１行分の配列
                self.questionDataArray.append(questionData) //格納用の配列に、１行ずつ追加していく
                }) //invokingからのクロージャここまで
            
            }catch let error {
                print("ファイル読み込みエラー:\(error)")
                return
        } //do節ここまで
    //問題の出題順をシャッフルする　配列内で要素をシャッフルする
    questionDataArray.shuffle() //これだけでOK
    }

    
    //問題文の取り出し  QuestionDataManeger.sharedInstance.nextQuestion() ****
    func nextQuestion() -> QuestionData? {
        if nowQuestionIndex < questionDataArray.count { //問題に残りがある時
            let nextQuestion = questionDataArray[nowQuestionIndex]
            nowQuestionIndex += 1 //次の問題へ
            return nextQuestion
        }
        return nil
    }
 
}
