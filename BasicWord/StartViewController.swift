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

            //問題を格納するための配列　　初期化が必要かな
      //      let questionDataArray = [QuestionData]() //QuestionDataの型
            QuestionDataManager.sharedInstance.questionDataArray = []//初期化してみる

             //データの読み込み　準備
             let thePath = NSHomeDirectory()+"/Documents/tempCSVFile.csv"

             do {
                let csvStringData = try String(contentsOfFile: thePath, encoding: String.Encoding.utf8)
                csvStringData.enumerateLines(invoking: {(line,stop) in //改行されるごとに分割する
                    let questionSourceDataArray = line.components(separatedBy: ",") //１行を","で分割して配列に入れる
                    let questionData = QuestionData(questionSourceDataArray: questionSourceDataArray)//１行分の配列
                    QuestionDataManager.sharedInstance.questionDataArray.append(questionData) //格納用の配列に、１行ずつ追加していく

                    }) //invokingからのクロージャここまで

             }catch let error as NSError {
                 print("ファイル読み込みに失敗。\n \(error)")
             } //Do節ここまで
            
        //次に表示する問題　UserDEfaultsStandaredの参照
        let defaults = UserDefaults.standard
        let nowQuestionNo = defaults.integer(forKey: "nowQuestionNo")//出題順を読み込みセットする
            

//次の問題文を表示する
        let nowQuestionIndex = nowQuestionNo //保存しておいた出題順番号
        //問題文の取り出し  QuestionDataManager.sharedInstance.nextQuestion() ****
            //保存しておいた番号を使って、問題を取り出す

        //StoryboardのIdentifierに設定した値("question")を使って、ViewControllerを生成する
        if let nextQuestionViewController = storyboard?.instantiateViewController(identifier: "question") as? QuestionViewController {
            nextQuestionViewController.nowQuestionNo = nowQuestionIndex//問題の出題順？
            nextQuestionViewController.questionNo = nowQuestionIndex//問題の出題順？
            //問題文の取り出し  sharedInstance.nextQuestion() ****
            guard let questionData = QuestionDataManager.sharedInstance.nextQuestion() else {
                    return
                }
            //問題文のセット
            nextQuestionViewController.questionData = questionData

        //セグエを利用せずに画面をモーダルで表示する
        present(nextQuestionViewController,animated: true,completion: nil)

        }

    }

 
}
