//
//  MultipleOptionQuestionnaireTableViewCell.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 01/02/21.
//

import UIKit

class MultipleOptionQuestionnaireTableViewCell: UITableViewCell, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    @IBOutlet weak var indicatorImage: UIImageView!
    
    private var questionnaireIndex = Int()
    private var questionnaireView = QuestionnaireViewController()
    
    private var selectedIndexes = [Int]()
    
    private var availableOptions = [String]()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        initSelectionTable()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    private func initSelectionTable() {
        answerTableView.delegate = self
        answerTableView.dataSource = self
        
        answerTableView.allowsSelection = true
        
        answerTableView.showsVerticalScrollIndicator = true
    }
    
    public func initQuestion(questionnaireView: QuestionnaireViewController, questionnaireIndex: Int, title: String, availableOptions: [String], allowsMultipleSelection: Bool) {
        self.questionnaireView = questionnaireView
        self.questionnaireIndex = questionnaireIndex
        self.questionTitle.text = title
        
        self.availableOptions = availableOptions
        self.answerTableView.allowsMultipleSelection = allowsMultipleSelection
    }
    
    @IBAction func onButtonClick(_ sender: Any) {
        saveData()
    }
    
    private func saveData() {
        // Save data in global dict.
        let answer = MultipleOptionsAnswer(questionTitle: self.questionTitle.text!, allowsMultipleSelection: self.answerTableView.allowsMultipleSelection, answers: self.selectedIndexes)
        self.questionnaireView.saveAnswer(index: self.questionnaireIndex, answer: answer)
        
        changeAnsweredIndicator(answered: true)
    }
    
    public func updateSavedData(answer: MultipleOptionsAnswer) {
        changeAnsweredIndicator(answered: true)
        self.answerTableView.reloadData()
    }
    
    public func updateEmptyData() {
        self.selectedIndexes = []
        self.answerTableView.deselectAllRows(animated: false)
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
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.availableOptions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel!.text = self.availableOptions[indexPath.row]
        cell.selectionStyle = .blue
        
        // As you need to select the rows on the go, check if the answer is saved when reusing cells.
        if let answers = self.questionnaireView.answers[questionnaireIndex] {
            if (answers as! MultipleOptionsAnswer).answers.contains(indexPath.row) {
                // Index saved, select the row again!
                tableView.selectRow(at: indexPath, animated: true, scrollPosition: UITableView.ScrollPosition.none)
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedIndexes.append(indexPath.row)
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        if let index = self.selectedIndexes.firstIndex(of: indexPath.row) {
            self.selectedIndexes.remove(at: index)
        }
    }
    
}
