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

