//
//  StartViewController.swift
//  BasicWord
//
//  Created by 森部高昌 on 2020/04/30.
//  Copyright © 2020 森部高昌. All rights reserved.
//

import UIKit

class StartViewController: UIViewController {
 
    let singleton:Singleton = Singleton.sharedInstance//シングルトンインスタンス******

    @IBOutlet weak var gradeSegment: UISegmentedControl! //学年名
    @IBOutlet weak var unitSegment: UISegmentedControl!  //単元名

     
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    
    //次画面に移る前の処理
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
             //userDefaultStandardに保存しておいた値をクリアする。
              //再開のために、中断時に保存しておいた値（問題の総数、正解数、問題の番号）
//        var questionCount:Int = 0 //問題の総数
//        var correctCount:Int = 0  //正解数
//        var nowQuestionNo:Int = 1 //現在出題している問題の番号
//              
//              let defaults = UserDefaults.standard      //UserDefaultsを参照する
//              let restartFlag = defaults.bool(forKey: "restartFlag")//再開用フラグ
// print("restartFlag:\(restartFlag)")
//              if restartFlag == true {
//
//                  questionCount = defaults.integer(forKey: "questionCount")//総問題数を読み込む
//                  correctCount = defaults.integer(forKey: "correctCount")//正解数を読み込む
//                  nowQuestionNo = defaults.integer(forKey: "nowQuestionNo")//出題順を読み込む
//
//              }
//
 
        
        //セグメンティッドコントロールから問題ファイル名を取得する
        var filename:String //ファイル名（拡張子を除いた本体のみ）
        //選択されているセグメントのインデックス（学年名）
        let selectedGradeIndex = gradeSegment.selectedSegmentIndex
        //選択されたインデックスの文字列を取得してファイル名（学年名）に設定する
        let text1 = gradeSegment.titleForSegment(at: selectedGradeIndex)
        //（単元名）
        let selectedUnitIndex = unitSegment.selectedSegmentIndex
        //（単元名）
        let text2 = unitSegment.titleForSegment(at: selectedUnitIndex)
        //ファイル名の生成　学年名＋単元名
        filename = text1! + text2!
        singleton.saveItem(item: filename) //ファイル名を　シングルトンへ保存　読み込みで使用
            
        //問題文の読み込み  sharedInstance.loadQuestion() ****
        QuestionDataManager.sharedInstance.loadQuestion()
        //遷移先画面の呼び出し
        guard let nextViewController = segue.destination as? QuestionViewController else {
                return
            }
        //問題文の取り出し  sharedInstance.nextQuestion() ****
        guard let questionData = QuestionDataManager.sharedInstance.nextQuestion() else {
                return
            }
        //問題文のセット
        nextViewController.questionData = questionData
        }
        
    //タイトルに戻ってくるときに呼び出される処理
    @IBAction func goToTitle(_ segue:UIStoryboardSegue){
    }
        

    
    
 //＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//再開ボタンを押した時
//        // 再開ボタンを押した時 保存した問題データと、UserDefaultsに保存した問題進行を読み込む
         @IBAction func clickRetryButton(_ sender: Any) {
//print("再開ボタン押下")
//print("再開直後のQuestionDataManager.sharedInstance.questionDataArray.count：\(QuestionDataManager.sharedInstance.questionDataArray.count)")//ここでは５
            //問題を格納するための配列　　初期化が必要かな
            let questionDataArray = [QuestionData]() //QuestionDataの型
            QuestionDataManager.sharedInstance.questionDataArray = []//初期化してみる
//print("初期化後のquestionDataArray：\(questionDataArray)")//[]
//print("初期化後のquestionDataArray.count:\(questionDataArray.count)")//0
             //データの読み込み　準備
             let thePath = NSHomeDirectory()+"/Documents/tempCSVFile.csv"

             do {
                let csvStringData = try String(contentsOfFile: thePath, encoding: String.Encoding.utf8)
                csvStringData.enumerateLines(invoking: {(line,stop) in //改行されるごとに分割する
                    let questionSourceDataArray = line.components(separatedBy: ",") //１行を","で分割して配列に入れる
                    let questionData = QuestionData(questionSourceDataArray: questionSourceDataArray)//１行分の配列
                    QuestionDataManager.sharedInstance.questionDataArray.append(questionData) //格納用の配列に、１行ずつ追加していく

                    }) //invokingからのクロージャここまで
print("questionDataArray[1]:\(QuestionDataManager.sharedInstance.questionDataArray[1].question)")//OK
print("questionDataArray.count:\(QuestionDataManager.sharedInstance.questionDataArray.count)") //5
                
             }catch let error as NSError {
                 print("ファイル読み込みに失敗。\n \(error)")
             } //Do節ここまで
 print(QuestionDataManager.sharedInstance.questionDataArray.count)//ここで１０になる
            
            
//    let totalNumberOfQuestions = QuestionDataManager.sharedInstance.questionDataArray.count //問題の総数
//    singleton.saveNumber(number: totalNumberOfQuestions) //問題の総数をシングルトンに保存しておく？？？？
//    //        //UserDefaultsStandardを使って、データを読み書きする
//    // let totalNumberOfQuestions = singleton.getNumber() //シングルトンから問題の総数を取り出す

            
let defaults = UserDefaults.standard      //UserDefaultsを参照する

let correctCount = defaults.integer(forKey: "correctCount")//正解数を読み込みセットする
let nowQuestionNo = defaults.integer(forKey: "nowQuestionNo")//出題順を読み込みセットする
let questionCount = defaults.integer(forKey: "questionCount")//総問題数を読み込みセットする
let restartFlag =  defaults.bool(forKey: "restartFlag")      //再開用フラグを読み込みセットする
//defaults.set(restartFlag,forKey: "true") //Flagをtrueにする
                        
print("restart正解数:correctCount:\(correctCount)")//2
print("restart出題順:nowQuestionNo:\(nowQuestionNo)")//3
print("restart総問題数:questionCount:\(questionCount)")//5
print("restartFlag:\(restartFlag)")
            

            
//次の問題文を表示する ？？？？？？？？？？？？？？？？？？？？？？？？？？？？？？
        let nowQuestionIndex = nowQuestionNo //保存しておいた出題順番号 ？？？？？
        //問題文の取り出し  QuestionDataManager.sharedInstance.nextQuestion() ****

        let nextQuestion = QuestionDataManager.sharedInstance.questionDataArray[nowQuestionIndex]//保存しておいた番号の問題

        //StoryboardのIdentifierに設定した値("question")を使って、ViewControllerを生成する

        if let nextQuestionViewController = storyboard?.instantiateViewController(identifier: "question") as? QuestionViewController {
//            nextQuestionViewController.totalNumberOfQuestions = questionCount//問題の総数を設定する
            nextQuestionViewController.questionData = nextQuestion//次の問題を設定する
            
print("正解数：correctCount:\(correctCount)")
print("現在の問題番号：nowQuestionIndex:\(nowQuestionIndex)")//
print("総問題数：questionCount:\(questionCount)")

        //presentメソッドは、セグエを利用せずに画面をモーダルで表示するメソッド
        present(nextQuestionViewController,animated: true,completion: nil)
            //nowQuestionNoがおかしい
            //questionCountは５でOK
            }

         }

 
}
