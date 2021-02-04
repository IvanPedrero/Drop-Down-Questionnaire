//
//  SignatureQuestionnaireTableViewCell.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 01/02/21.
//

import UIKit

class SignatureQuestionnaireTableViewCell: UITableViewCell {
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var signatureView: DrawingCanvas!
    @IBOutlet weak var indicatorImage: UIImageView!
    
    @IBOutlet var saveButton: UIButton!
    @IBOutlet var clearButton: UIButton!
    
    
    private var questionnaireIndex = Int()
    private var questionnaireView = QuestionnaireViewController()
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        stylizeSignatureViews()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func stylizeSignatureViews(){
        signatureView.stylizeCell()
    }
    
    public func initQuestion(questionnaireView: QuestionnaireViewController, questionnaireIndex: Int, title: String) {
        self.questionnaireView = questionnaireView
        self.questionnaireIndex = questionnaireIndex
        self.questionTitle.text = title
        
        signatureView.questionnaireTableView = questionnaireView.questionnaireTableView
    }
    
    @IBAction func onButtonClick(_ sender: Any) {
        let alert = UIAlertController(title: "Once submitted, you won't be able to change the signature", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Proceed", style: .default, handler: { action in
            self.saveData()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.questionnaireView.present(alert, animated: true)
    }
    
    @IBAction func onButtonClearClick(_ sender: Any) {
        self.signatureView.clear()
    }
    
    
    private func saveData() {
        if !signatureView.hasSigned { return }
        
        // Save data in global dict.
        let answer = SignatureAnswer(questionTitle: self.questionTitle.text!, signature: signatureView)
        self.questionnaireView.saveAnswer(index: questionnaireIndex, answer: answer)
        
        changeAnsweredIndicator(answered: true)
        enableInteractions(answered: true)
    }
    
    public func updateSavedData(answer: SignatureAnswer) {
        self.signatureView = answer.signature
        changeAnsweredIndicator(answered: true)
        enableInteractions(answered: true)
    }
    
    public func updateEmptyData() {
        self.signatureView.clear()
        changeAnsweredIndicator(answered: false)
        enableInteractions(answered: false)
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
    
    private func enableInteractions(answered: Bool) {
        self.saveButton.isHidden = answered
        self.clearButton.isHidden = answered
        self.signatureView.isUserInteractionEnabled = !answered
    }
    
}
