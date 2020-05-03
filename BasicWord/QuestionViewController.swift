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
        
        
        override func viewDidLoad() {
            super.viewDidLoad()
            
            //問題数の取得  QuestionDataManeger.sharedInstance.questionDataArray****
            let totalNumberOfQuestions = QuestionDataManeger.sharedInstance.questionDataArray.count//問題数
 //           let questionNo = Singleton.sharedInstance.getNumber() //今は何問目か・・・不必要になった
 //           let defaults = UserDefaults.standard      //UserDefaultsを参照する
 //           let qCount = defaults.integer(forKey: "qCount")//問題総数を読み込む
            
//                if  totalNumberOfQuestions == 0 {
//                    totalNumberOfQuestions = qCount //問題の総数。途中で保存して再開した場合に、この値を使う
//                }
            
            //初期データ設定。前画面から受け取ったquestionDataから値を取り出す
            questionNoLabel.text = "Q.\(questionData.questionNo)" + "/\(totalNumberOfQuestions)"//　出題順/問題数合計 シャッフルしたので出題順がちがう
            questionTextView.text = questionData.question //問題文
            answer1Button.setTitle(questionData.answer1, for: UIControl.State.normal)
            answer2Button.setTitle(questionData.answer2, for: UIControl.State.normal)
            answer3Button.setTitle(questionData.answer3, for: UIControl.State.normal)
            answer4Button.setTitle(questionData.answer4, for: UIControl.State.normal)
            trueAnswer.text = questionData.correctAnswer //正答
        
            //解答の進行状況を表示する プログレスビューの表示
                var degree:Float = 0.0 //進み具合
                degree = Float(questionData.questionNo) / Float(totalNumberOfQuestions)
                progressView.progress = degree //progressView を動かす
            
        }
        // end of override func viewDidLoad() ------------------------------------------------

    
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
    
    
    func goNextQuestion()  {
    //問題文の取り出し  QuestionDataManeger.sharedInstance.nextQuestion ****
    //変数の点検 ここから次の問題へ nowQuestionIndex:0 questionDataArray.count:0 になっている
            
        guard let nextQuestion = QuestionDataManeger.sharedInstance.nextQuestion() else {
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
            //presentメソッドは、セグエを利用せずに画面をモーダルで表示するメソッド
            if let nextQuestionViewController = storyboard?.instantiateViewController(identifier: "question") as? QuestionViewController {
                nextQuestionViewController.questionData = nextQuestion
                //StoryboardのSegueを利用しない明示的な画面遷移処理
                present(nextQuestionViewController,animated: true,completion: nil)
            }
    }
    //＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    //中断する　ボタンを押した時　？？？？？？
    @IBAction func clickStopButton(_ sender: UIButton) {

       //問題の保存
       //問題の取得  QuestionDataManeger.sharedInstance.questionDataArray****
        let listArray = QuestionDataManeger.sharedInstance.questionDataArray
        let questionCount = QuestionDataManeger.sharedInstance.questionDataArray.count//問題数
        
        //配列をCSVファイルに変換する
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
//print(csvString)

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
        //正解数を計算する  QuestionDataManeger.sharedInstance.questionDataArray ******
            for questionData in QuestionDataManeger.sharedInstance.questionDataArray {
                if questionData.isCorrect() {
                    correctCount += 1
                }
            }
        
        
//ユーザーデフォルトを参照する。正解数、出題順、を保存　　問題の総数は、ファイル読込の段階で行う
        //QuestionDataManager.loadQuestion()で
 
        let defaults = UserDefaults.standard                 //ユーザーデフォルトを参照する
        defaults.set(correctCount, forKey: "correctCount") //正解数を"correctCount"として保存する
        defaults.set(questionData.questionNo, forKey: "nowQuestionNo")//次の問題の出題順を"nowQuestionNo"として保存する
        
//UserDefaultsStandardに保存した値の確認
print("正解数:defaults.correctCount:\(correctCount)")
print("次出題順:defaults.nowQuestionNo:\(questionData.questionNo)")
print("総問題数:defaults.questionCount:\(questionCount)")
        
        
    //スタート画面に戻る　StartViewControllerへ
    //StoryboardのIdentifierに設定した値("start")を使って、ViewControllerを生成する
    //presentメソッドは、セグエを利用せずに画面をモーダルで表示するメソッド
        if let nextQuestionViewController = storyboard?.instantiateViewController(identifier: "start") as? StartViewController {
            present(nextQuestionViewController,animated: true,completion: nil)
        }
        

    }
    
}
