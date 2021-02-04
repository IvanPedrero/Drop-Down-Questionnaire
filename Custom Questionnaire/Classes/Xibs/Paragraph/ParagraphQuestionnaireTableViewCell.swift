//
//  TextQuestionnaireTableViewCell.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 30/01/21.
//

import UIKit

class ParagraphQuestionnaireTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var answerTextField: UITextField!
    @IBOutlet weak var indicatorImage: UIImageView!
    
    private var questionnaireIndex = Int()
    private var questionnaireView = QuestionnaireViewController()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    public func initQuestion(questionnaireView: QuestionnaireViewController, questionnaireIndex: Int, title: String) {
        self.questionnaireView = questionnaireView
        self.questionnaireIndex = questionnaireIndex
        self.questionTitle.text = title
    }
    
    @IBAction func onButtonClick(_ sender: Any) {
        saveData()
    }
    
    private func saveData() {
        if answerTextField.text == "" || answerTextField.text == nil { return }
        
        // Save data in global dict.
        let answer = ParagraphAnswer(questionTitle: self.questionTitle.text!, answer: answerTextField.text!)
        self.questionnaireView.saveAnswer(index: questionnaireIndex, answer: answer)
        
        changeAnsweredIndicator(answered: true)
    }
    
    public func updateSavedData(answer: ParagraphAnswer) {
        self.answerTextField.text = answer.answer
        changeAnsweredIndicator(answered: true)
    }
    
    public func updateEmptyData() {
        self.answerTextField.text = ""
        changeAnsweredIndicator(answered: false)
    }
    
    private func changeAnsweredIndicator(answered: Bool) {
        if answered {
            self.indicatorImage.image = UIImage(systemName: "circle.fill")
            self.indicatorImage.image = self.indicatorImage.image!.tint(with: UIColor.systemGreen)
        }
        else {
            self.indicatorImage.image = UIImage(systemName: "circle")
            self.indicatorImage.image = self.indicatorImage.image!.tint(with: UIColor.systemRed)
        }
    }
}
