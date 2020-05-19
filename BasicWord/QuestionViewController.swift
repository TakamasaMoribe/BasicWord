//
//  QuestionViewController.swift
//  BasicWord
//
//  Created by 森部高昌 on 2020/04/30.
//  Copyright © 2020 森部高昌. All rights reserved.
//

import UIKit
import AudioToolbox

class QuestionViewController: UIViewController {
    
    let singleton:Singleton = Singleton.sharedInstance
        
    var filename:String = ""       //問題データのCSVファイル名本体部分
    var questionData:QuestionData! //前画面より受け取るデータ
    var totalNumberOfQuestions:Int = 0      //問題の総数

    var correctCount:Int = 0  //正解数
    var nowQuestionNo:Int = 1 //現在出題している問題の番号・・前画面より引き継ぐ？？？？？？？？
    var questionNo:Int = 1 //現在出題している問題の番号・・前画面より引き継ぐ？？？？？？？？
        
    @IBOutlet weak var progressView: UIProgressView! //解答の進行状況
        
    @IBOutlet weak var questionNoLabel: UILabel!     //問題番号
    @IBOutlet weak var questionTextView: UITextView! //問題文
    @IBOutlet weak var answer1Button: UIButton!      //選択肢１
    @IBOutlet weak var answer2Button: UIButton!      //選択肢２
    @IBOutlet weak var answer3Button: UIButton!      //選択肢３
    @IBOutlet weak var answer4Button: UIButton!      //選択肢４

    @IBOutlet weak var correctImageView: UIImageView!  //正解の画像 ◯
    @IBOutlet weak var incorrectImageView: UIImageView!//不正解の画像　✗
        
    @IBOutlet weak var trueAnswer: UILabel!          //不正解の時、正解を示す hide属性
    @IBOutlet weak var nextQuestionButton: UIButton! //次の問題へ進むボタン　 hide
    
        @IBOutlet weak var button1: UIButton! //選択肢ボタン装飾のため
        @IBOutlet weak var button2: UIButton! //
        @IBOutlet weak var button3: UIButton! //
        @IBOutlet weak var button4: UIButton! //
    
    
        
    override func viewDidLoad() {
            super.viewDidLoad()
        
        //テキストビューの装飾
        let view = questionTextView! //UIView()
        view.layer.borderColor = UIColor.black.cgColor// 枠線の色
        view.layer.borderWidth = 2// 枠線の太さ
        view.layer.cornerRadius = 5// 面取り
        
        // ボタンの装飾
            designButton(buttonObj: button1!) //選択肢１ボタンの装飾
            designButton(buttonObj: button2!) //
            designButton(buttonObj: button3!) //
            designButton(buttonObj: button4!) //
        
        //問題数と出題順の取得  sharedInstance.questionDataArray****　次の問題へ進むたびにここに戻って画面表示をする
        let totalNumberOfQuestions = QuestionDataManager.sharedInstance.questionDataArray.count//問題の総数
        var nowQuestionNo = questionData.questionNo //現在の出題順
        
        //再開用フラグを使用して、保存した値を使うかどうか判断する
        let defaults = UserDefaults.standard      //UserDefaultsを参照する
        var restartFlag = defaults.bool(forKey: "restartFlag") //再開用フラグを読み込む

            if restartFlag == true { //中断を再開するときは、保存した値を読み込む
                //正解数を読み込む
                QuestionDataManager.sharedInstance.correctCount = defaults.integer(forKey: "correctCount")
                //出題順を読み込む
                QuestionDataManager.sharedInstance.nowQuestionIndex = defaults.integer(forKey: "nowQuestionNo")
                //現在の問題番号を取得する。上の行もこの行も必要
                nowQuestionNo = QuestionDataManager.sharedInstance.nowQuestionIndex
                    restartFlag = false  //再開して１回目に読み込んだら、フラグをfalseに戻しておく
                    defaults.set(restartFlag, forKey: "restartFlag")
                
            } else {
                //現在の問題番号を取得する
                nowQuestionNo = QuestionDataManager.sharedInstance.nowQuestionIndex
            }
        
        //初期データ設定。前画面から受け取ったquestionDataから値を取り出す
        questionNoLabel.text = "Q.\(nowQuestionNo)" + "/\(totalNumberOfQuestions)"//　出題順/問題の総数
            questionTextView.text = questionData.question //問題文
            answer1Button.setTitle(questionData.answer1, for: UIControl.State.normal) //選択肢１
            answer2Button.setTitle(questionData.answer2, for: UIControl.State.normal) //選択肢２
            answer3Button.setTitle(questionData.answer3, for: UIControl.State.normal) //選択肢３
            answer4Button.setTitle(questionData.answer4, for: UIControl.State.normal) //選択肢４
            trueAnswer.text = questionData.correctAnswer //正答
        
        //解答の進行状況を表示する プログレスビューの表示
        var degree:Float = 0.0 //進み具合
        degree = Float(nowQuestionNo) / Float(totalNumberOfQuestions)
        //太さ（高さ）を５にする
        progressView.transform = CGAffineTransform(scaleX: 1.0, y: 5.0)
        progressView.progress = degree //progressView を動かす
            
    }
    // end of override func viewDidLoad() ------------------------------------------------

    
//ボタンの装飾
    func designButton(buttonObj:UIButton)  {
        let button:UIButton = buttonObj //buttonに引数buttonObjを設定する
        let rgba = UIColor(red: 50/255, green: 255/255, blue: 0/255, alpha: 0.3) // ボタン背景色設定
        button.backgroundColor = rgba                                     // 背景色
        button.layer.borderWidth = 0.5                                    // 枠線の幅
        button.layer.borderColor = UIColor.black.cgColor                  // 枠線の色
        button.layer.cornerRadius = 2.0                                   // 角丸のサイズ
        button.setTitleColor(UIColor.black, for: UIControl.State.normal)  // タイトルの色
    }
    
    
    //選択肢１を選んだ時
     @IBAction func tapAnswer1Button(_ sender: Any) {
         questionData.userChoiceAnswer = answer1Button.title(for: UIControl.State.normal)!//answer1を選んだ
         goNextQuestionWithAnimation()
     }
     //選択肢2を選んだ時
     @IBAction func tapAnswer2Button(_ sender: Any) {
         questionData.userChoiceAnswer = answer2Button.title(for: UIControl.State.normal)!//answer2を選んだ
      goNextQuestionWithAnimation()
     }
     //選択肢3を選んだ時
     @IBAction func tapAnswer3Button(_ sender: Any) {
         questionData.userChoiceAnswer = answer3Button.title(for: UIControl.State.normal)!//answer3を選んだ
         goNextQuestionWithAnimation()
     }
     //選択肢4を選んだ時
     @IBAction func tapAnswer4Button(_ sender: Any) {
         questionData.userChoiceAnswer = answer4Button.title(for: UIControl.State.normal)!//answer4を選んだ
         goNextQuestionWithAnimation()
     }

    //正誤判定を経て、次の問題へ進む
    func goNextQuestionWithAnimation()  {
        if questionData.isCorrect() {
            goCorrectAnimation()   //正解の時
        }else{
            goIncorrectAnimation() //不正解の時
        }
    }

    //正答の時
    func goCorrectAnimation()  {
        AudioServicesPlayAlertSound(1025) //正解音を鳴らす
        //正解のイメージとアニメーション
        UIView.animate(withDuration: 1.0, animations: {self.correctImageView.alpha = 1.0
        }){(Bool) in self.goNextQuestion() //アニメーション後に次の問題へ進む
        }
    }
    
    //誤答の時
    func goIncorrectAnimation()  {
        AudioServicesPlayAlertSound(1006) //誤答音を鳴らす
        //不正解のイメージとアニメーション
        UIView.animate(withDuration: 1.0, animations: {self.incorrectImageView.alpha = 1.0})
        {(Bool) in self.showCorrectAnswer() //正答を表示する
        }
    }
   
    //誤答の時には、正答を表示する
    func showCorrectAnswer()  {
        trueAnswer.isHidden = false//HIDDEN　解除
        trueAnswer.text = "正解は:" + questionData.correctAnswer // 正答表示
        nextQuestionButton.isHidden = false//HIDDENを解除してボタンを表示する
        //"次へ"ボタンのクリックで、goNextQuestion() //次の問題へ進む
    }

    //"次へ"ボタンのクリック
    @IBAction func tapNextButton(_ sender: UIButton) {
        goNextQuestion() //次の問題へ進む
    }
    
    //------------------------------------------------------------------------------
    func goNextQuestion()  {
    //問題文の取り出し
            
        guard let nextQuestion = QuestionDataManager.sharedInstance.nextQuestion() else {
            //問題文に残りがない時 ＝ 最後の問題の時は、結果表示画面へすすむ
            //StoryboardのIdentifierに設定した値("result")を使って、ViewControllerを生成する
            if let resultViewController = storyboard?.instantiateViewController(withIdentifier: "result") as? ResultViewController {
                //StoryboardのSegueを利用しない明示的な画面遷移処理
                present(resultViewController,animated: true,completion: nil)
            }
            return
        }
            
            //問題文に残りがあり、次の問題文を表示する時
            //StoryboardのIdentifierに設定した値("question")を使って、ViewControllerを生成する
            if let nextQuestionViewController = storyboard?.instantiateViewController(identifier: "question") as? QuestionViewController {
                nextQuestionViewController.questionData = nextQuestion
                //StoryboardのSegueを利用しない明示的な画面遷移処理
                present(nextQuestionViewController,animated: true,completion: nil)
            }
    }
    // end of func goNextQuestion() ------------------------------------------------
 
    
    //＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    //中断する　ボタンを押した時
    @IBAction func clickStopButton(_ sender: UIButton) {

       //問題の保存     flagを立てておく restart == true
       //問題の取得  QuestionDataManager.sharedInstance.questionDataArray****
        let listArray = QuestionDataManager.sharedInstance.questionDataArray //一時的な問題データ配列
        let questionCount = QuestionDataManager.sharedInstance.questionDataArray.count//問題数
        
        //配列をCSVファイルに変換する。１問ごとに改行をする
        var csvString = ""
        var item = ""

            for i in 0 ..< questionCount{
                item = listArray[i].originNo + ","
                item = item + listArray[i].question + ","
                item = item + listArray[i].correctAnswer + ","
                item = item + listArray[i].answer1 + ","
                item = item + listArray[i].answer2 + ","
                item = item + listArray[i].answer3  + ","
                item = item + listArray[i].answer4 + "\n" //改行
                csvString += item
            }

        //問題の保存 csvファイルとして保存する
        let thePath = NSHomeDirectory()+"/Documents/tempCSVFile.csv"
        let textData = csvString
            do {
                try textData.write(toFile:thePath,atomically:true,encoding:String.Encoding.utf8)
            }catch let error as NSError {
                print("保存に失敗。\n \(error)")
            }
            
        //正解数の取得
        var correctCount:Int = 0
        //正解数を計算する  QuestionDataManager.sharedInstance.questionDataArray ******
            for questionData in QuestionDataManager.sharedInstance.questionDataArray {
                if questionData.isCorrect() {
                    correctCount += 1
                }
            }
        
        //ユーザーデフォルトを参照する。再開フラグ、正解数、出題順、を保存　　問題の総数は、ファイル読込の段階で行う
        let restartFlag:Bool = true               //再開フラグをtrueに設定する
        let defaults = UserDefaults.standard      //ユーザーデフォルトを参照する
        defaults.set(restartFlag, forKey: "restartFlag") //再開フラグをtrueを"restartFlag"の名で保存する
        defaults.set(correctCount, forKey: "correctCount") //正解数を"correctCount"の名で保存する
        defaults.set(questionData.questionNo, forKey: "nowQuestionNo")//次の問題の出題順を"nowQuestionNo"の名で保存する
        
    //スタート画面に戻る　StartViewControllerへ
    //StoryboardのIdentifierに設定した値("start")を使って、ViewControllerを生成する

        if let nextQuestionViewController = storyboard?.instantiateViewController(identifier: "start") as? StartViewController {
            present(nextQuestionViewController,animated: true,completion: nil)
        }

    }
    // end of func @IBAction func clickStopButton -----------------------------------------------
    
}
