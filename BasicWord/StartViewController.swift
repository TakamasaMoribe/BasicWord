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
    @IBOutlet weak var retryButton: UIButton!            //「中断からの再開」ボタン

    
    // 画面表示前の準備　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    override func viewWillAppear(_ animated: Bool) {
        //再開フラグを読み込み、「中断からの再開」ボタンの表示を決める
        let defaults = UserDefaults.standard
        let restartFlag = defaults.bool(forKey: "restartFlag")
            if restartFlag == true {
                retryButton.isHidden = false//中断後の再開フラグがtrueのときは、表示する
            }else{
                   retryButton.isHidden = true//中断後ではないときは、非表示のままにしておく
            }
          //このあとの処理で、ボタンを押したならば、非表示にする　(retryButton.isHidden = false)
        
      }
     // end of  override func viewWillAppear()  -------------------------------------------------

    
    // 画面表示後の処理　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
    override func viewDidLoad() {
        super.viewDidLoad()
        //セグメンティッドコントロールの装飾
        let font1 = UIFont.systemFont(ofSize: 20)//学年選択
        gradeSegment.setTitleTextAttributes([NSAttributedString.Key.font: font1], for: .normal)
        // セグメントの背景色の設定
        gradeSegment.backgroundColor = UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 0.2)
        // 選択されたセグメントの背景色の設定
        gradeSegment.selectedSegmentTintColor = UIColor(red: 1.00, green: 1.00, blue: 0.00, alpha: 1.0)
        
        let font2 = UIFont.systemFont(ofSize: 18)//分野選択
        unitSegment.setTitleTextAttributes([NSAttributedString.Key.font: font2], for: .normal)
        // セグメントの背景色の設定
        unitSegment.backgroundColor = UIColor(red: 0.00, green: 1.00, blue: 0.00, alpha: 0.2)
        // 選択されたセグメントの背景色の設定
        unitSegment.selectedSegmentTintColor = UIColor(red: 1.00, green: 1.00, blue: 0.00, alpha: 1.0)
        
    }
    // end of  override func viewDidLoad()  -------------------------------------------------

        
    //次画面に移る前の処理　＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
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
        
        //UserDefaultsStandardの参照
        let restartFlag:Bool = false              //再開用フラグをfalseに戻しておく
        let defaults = UserDefaults.standard      //UserDefaultsを参照する
        defaults.set(restartFlag, forKey: "restartFlag") //Flagをfalseに戻す
        
    }
    // end of   override func prepare(for segue: UIStoryboardSegue)--------------------------
        
    
    //タイトルに戻ってくるときに呼び出される処理
    @IBAction func goToTitle(_ segue:UIStoryboardSegue){
    }
        
    
    
//＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝＝
//「中断からの再開」ボタンを押した時
// 保存した問題データと、UserDefaultsに保存した問題進行を読み込む
    @IBAction func clickRetryButton(_ sender: Any) {
        
    //「中断からの再開」ボタンを非表示に戻しておく
        retryButton.isHidden = true//中断語ではないときは、非表示のままにしておく

    //問題を格納するための配列 questionDataArray = [QuestionData]() //QuestionDataの型
    QuestionDataManager.sharedInstance.questionDataArray = []//初期化してみる

    //データの読み込み　準備
    let thePath = NSHomeDirectory()+"/Documents/tempCSVFile.csv"

        do {
            let csvStringData = try String(contentsOfFile: thePath, encoding: String.Encoding.utf8)
            csvStringData.enumerateLines(invoking: {(line,stop) in //改行されるごとに分割する
                let questionSourceDataArray = line.components(separatedBy: ",") //１行を","で分割して配列に入れる
                let questionData = QuestionData(questionSourceDataArray:questionSourceDataArray) //１行分の配列
                    QuestionDataManager.sharedInstance.questionDataArray.append(questionData)
                    //格納用の配列に、１行ずつ追加していく
//questionData.questionNoが必要か？
//問題番号を設定 =questionDataArrayに追加した順番を表す
questionData.questionNo = QuestionDataManager.sharedInstance.questionDataArray.count//問題の累積数 １からの序数になる
                }) //invokingからのクロージャここまで

            
            
            }catch let error as NSError {
                 print("ファイル読み込みに失敗。\n \(error)")
        } //Do節ここまで
        
    //次の問題文を表示する。シャッフルは不要。中断時にシャッフル済の状態で保存してある。
    //次に表示する問題。出題順を読み込みセットする。
    let defaults = UserDefaults.standard
    QuestionDataManager.sharedInstance.nowQuestionIndex = defaults.integer(forKey: "nowQuestionNo")
    //QuestionViewの画面で中断したときに、すでに次の問題が表示されているので１つ戻す
    QuestionDataManager.sharedInstance.nowQuestionIndex -= 1//２回目の中断再開のときに−１になる？？？？
        //一度、中断からの再開をしたときに、０になるか？？？？
print("QuestionDataManager.sharedInstance.nowQuestionIndex:\(QuestionDataManager.sharedInstance.nowQuestionIndex)")
    //StoryboardのIdentifierに設定した値("question")を使って、ViewControllerを生成する
        if let nextQuestionViewController = storyboard?.instantiateViewController(identifier: "question") as? QuestionViewController {
            //問題文の取り出し
            guard let questionData = QuestionDataManager.sharedInstance.nextQuestion() else {
                    return
                }
            //問題文のセット
            nextQuestionViewController.questionData = questionData
            //セグエを利用せずに画面をモーダルで表示する
            present(nextQuestionViewController,animated: true,completion: nil)
        }

    }
    // end of  @IBAction func clickRetryButton --------------------------------------------
 
}

