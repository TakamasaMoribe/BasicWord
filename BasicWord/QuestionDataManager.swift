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
    
    //ｃｓｖファイルから取り出すデータ
    var originNo:String       //問題番号 固有の番号
    var question:String       //問題文
    var correctAnswer:String  //正解
    var answer1:String        //選択肢１
    var answer2:String        //選択肢２
    var answer3:String        //選択肢３
    var answer4:String        //選択肢４
    
    //プログラム実行中に取得するデータ
    var userChoiceAnswer:String?       //ユーザーが選択した答
    var questionCount:Int = 0          //総問題数？？？？？不要？？？
    var questionNo:Int = 0             //現在の問題の番号？？？？？
    var correctCount:Int = 0           //ユーザーが正解した数
    
    //イニシャライザー　配列questionSourceDataArrayを受け取ることができる
    init(questionSourceDataArray:[String]) {
        originNo = questionSourceDataArray[0]      //問題番号
        question = questionSourceDataArray[1]      //問題文
        correctAnswer = questionSourceDataArray[2] //正解
        answer1 = questionSourceDataArray[3]       //選択肢１
        answer2 = questionSourceDataArray[4]       //選択肢２
        answer3 = questionSourceDataArray[5]       //選択肢３
        answer4 = questionSourceDataArray[6]       //選択肢４
    }
    
    //正誤の判定をして、Bool値を返す　Boolではなく、Intで返せば、正解数の保持は可能？
    func isCorrect() -> Bool {
        if correctAnswer == userChoiceAnswer {
            correctCount += 1 //正解の数を１つ増やす？？どこでどうやって使う
            QuestionDataManager.sharedInstance.correctCount += 1//正解の数を１つ増やす？？追加

            return true//正解
        }
        return false   //不正解
    }
    
}
// end of class QuestionData =============================================


class QuestionDataManager {
        
    var filename:String = ""  //問題ファイルの名前
    
    //シングルトン  sharedInstance = QuestionDataManager() ******
    static let sharedInstance = QuestionDataManager()
    
    //問題を格納するための配列
    var questionDataArray = [QuestionData]()
    
    //現在の問題のインデックス
    var nowQuestionIndex:Int = 0//何問目かを表すインデックス
    
    //正解数
    var correctCount:Int = 0 //正解数の累計値
    
    //シングルトンであることを保証するために初期化する
    private init(){
    }
    

    //問題の読み込み　QuestionDataManager.sharedInstance.loadQuestion() ****
    func loadQuestion()  {
        questionDataArray.removeAll() //古いデータ配列を消去しておく
        nowQuestionIndex = 0          //何問目かも初期化：nextQuestion()で、＋１する
        let singleton:Singleton = Singleton.sharedInstance//ファイル名用のシングルトン******
        let filename = singleton.getItem() //ファイル名をシングルトンから読み込む
        
        //問題ファイルのパスを指定する　セクメンティッドコントロールから取得する
        guard let csvFilePath = Bundle.main.path(forResource: filename, ofType: "csv") else {
            print("ファイルが存在しません")//エラー処理が欲しい
            return
        }
        

        //CSV問題ファイルからデータを読み込む
        //クロージャ:関数の実行結果を次の処理で続けて使用する関数
        //enumerateLinesは改行（\n (バックスラッシュ + n))単位で文字列を読み込むメソッド
        //stopはそのままの意味でstop変数にtrueを代入した時にループが終了する
        //lineやstopは決められた名前ではなく、自分の好きな名前を付けられる
        do {
            let csvStringData = try String(contentsOfFile: csvFilePath,encoding: String.Encoding.utf8)
            
            csvStringData.enumerateLines(invoking: {(line,stop) in //改行されるごとに分割する
                let questionSourceDataArray = line.components(separatedBy: ",") //１行を","で分割して配列に入れる
                let questionData = QuestionData(questionSourceDataArray: questionSourceDataArray)//１行分の配列
                    //QuestionDataクラスのインスタンスとして、１つの問題文を入れる
                self.questionDataArray.append(questionData) //格納用の配列に、１行（１つの問題文）ずつ追加していく
                //問題番号を設定 =questionDataArrayに追加した順番を表す
                questionData.questionNo = self.questionDataArray.count//問題の累積数 １からの序数になる

                }) //invokingからのクロージャここまで

            
            }catch let error {
                print("ファイル読み込みエラー:\(error)")
                return
            } //do節ここまで


    //問題の出題順をシャッフルする　配列内で要素をシャッフルする
    questionDataArray.shuffle() //シャッフルそのものは、これだけでOK
        
    //シャッフル後の出題順 出題順questionNoを、１から昇順につけ直す

        for i in 0..<questionDataArray.count {
            questionDataArray[i].questionNo = i + 1 //０から始まるので+1
        }
        
        
    //ユーザーデフォルトに変数を保存する。（問題の総数）   再起動の可能性があるので、singletonは使用しない。
    //ここでは、問題の総数questionDataArray.countを"totalNumberOfQuestions"として保存する
        let defaults = UserDefaults.standard                 //ユーザーデフォルトを参照する
        defaults.set(questionDataArray.count, forKey: "totalNumberOfQuestions") //問題の総数を保存する
        
        
    }
  // end of func loadQuestion() -----------------------------------------

    
    //問題文の取り出し  QuestionDataManager.sharedInstance.nextQuestion() ****
    func nextQuestion() -> QuestionData? {
        if nowQuestionIndex < questionDataArray.count { //問題に残りがある時

            let nextQuestion = questionDataArray[nowQuestionIndex]
            nowQuestionIndex += 1
            return nextQuestion //次の問題へ
        }
        return nil //全部解き終わって、次の問題がない時
    }
 
}
