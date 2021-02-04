//
//  ViewController.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 30/01/21.
//

import UIKit

class QuestionnaireViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var questionnaireTableView: UITableView!
    
    var questions: [Any] = []
    
    var answers = [Int: Any]()
    
    var selectedIndex: Int = -1
    var isCollapsed: Bool = false
    
    let cellPadding: CGFloat = 10
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        getQuestionsFromSampleJson()
        
        initQuestionnaireTable()
        registerCells()
    }
    
    private func initQuestionnaireTable() {
        questionnaireTableView.delegate = self
        questionnaireTableView.dataSource = self
        
        questionnaireTableView.estimatedRowHeight = 220
        questionnaireTableView.rowHeight = UITableView.automaticDimension
        
        questionnaireTableView.tableFooterView = UIView()
    }
    
    private func registerCells() {
        let shortAnswerNib = UINib.init(nibName: "ShortQuestionnaireTableViewCell", bundle: nil)
        self.questionnaireTableView.register(shortAnswerNib, forCellReuseIdentifier: "ShortQuestionnaireTableViewCell")
        
        let paragraphNib = UINib.init(nibName: "ParagraphQuestionnaireTableViewCell", bundle: nil)
        self.questionnaireTableView.register(paragraphNib, forCellReuseIdentifier: "ParagraphQuestionnaireTableViewCell")
        
        let photoNib = UINib.init(nibName: "PhotoQuestionnaireTableViewCell", bundle: nil)
        self.questionnaireTableView.register(photoNib, forCellReuseIdentifier: "PhotoQuestionnaireTableViewCell")
        
        let signatureNib = UINib.init(nibName: "SignatureQuestionnaireTableViewCell", bundle: nil)
        self.questionnaireTableView.register(signatureNib, forCellReuseIdentifier: "SignatureQuestionnaireTableViewCell")
        
        let multipleOptionNib = UINib.init(nibName: "MultipleOptionQuestionnaireTableViewCell", bundle: nil)
        self.questionnaireTableView.register(multipleOptionNib, forCellReuseIdentifier: "MultipleOptionQuestionnaireTableViewCell")
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
                
        let question = questions[indexPath.section]
        
        if question is Short {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ShortQuestionnaireTableViewCell", for: indexPath) as! ShortQuestionnaireTableViewCell
            
            // Init cell.
            cell.initQuestion(questionnaireView: self, questionnaireIndex: indexPath.section, title: (question as! Short).title)
            
            cell.stylizeCell()
            
            // Check if the answer exists in the saved dict array.
            let answerExists = answers[indexPath.section] != nil
            if answerExists {
                cell.updateSavedData(answer: answers[indexPath.section] as! ShortAnswer)
            }
            else{
                cell.updateEmptyData()
            }

            return cell
        }
        else if question is Paragraph {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "ParagraphQuestionnaireTableViewCell", for: indexPath) as! ParagraphQuestionnaireTableViewCell
            
            // Init cell.
            cell.initQuestion(questionnaireView: self, questionnaireIndex: indexPath.section, title: (question as! Paragraph).title)
            
            cell.stylizeCell()
            
            // Check if the answer exists in the saved dict array.
            let answerExists = answers[indexPath.section] != nil
            if answerExists {
                cell.updateSavedData(answer: answers[indexPath.section] as! ParagraphAnswer)
            }
            else{
                cell.updateEmptyData()
            }
            
            return cell
        }
        else if question is Photo {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "PhotoQuestionnaireTableViewCell", for: indexPath) as! PhotoQuestionnaireTableViewCell
            
            // Init cell.
            cell.initQuestion(questionnaireView: self, questionnaireIndex: indexPath.section, title: (question as! Photo).title)
            
            cell.stylizeCell()
            
            // Check if the answer exists in the saved dict array.
            let answerExists = answers[indexPath.section] != nil
            if answerExists {
                cell.updateSavedData(answer: answers[indexPath.section] as! PhotoAnswer)
            }
            else{
                cell.updateEmptyData()
            }
            
            return cell
        }
        else if question is Signature {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "SignatureQuestionnaireTableViewCell", for: indexPath) as! SignatureQuestionnaireTableViewCell
            
            // Init cell.
            cell.initQuestion(questionnaireView: self, questionnaireIndex: indexPath.section, title: (question as! Signature).title)
            
            cell.stylizeCell()
            
            // Check if the answer exists in the saved dict array.
            let answerExists = answers[indexPath.section] != nil
            if answerExists {
                cell.updateSavedData(answer: answers[indexPath.section] as! SignatureAnswer)
            }
            else{
                cell.updateEmptyData()
            }
            
            return cell
        }
        else if question is MultipleOptions {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MultipleOptionQuestionnaireTableViewCell", for: indexPath) as! MultipleOptionQuestionnaireTableViewCell
            
            // Init cell.
            cell.initQuestion(questionnaireView: self, questionnaireIndex: indexPath.section, title: (question as! MultipleOptions).title, availableOptions: (question as! MultipleOptions).availableOptions, allowsMultipleSelection: (question as! MultipleOptions).allowsMultipleSelection)
            
            cell.stylizeCell()
            
            // Check if the answer exists in the saved dict array.
            let answerExists = answers[indexPath.section] != nil
            if answerExists {
                cell.updateSavedData(answer: answers[indexPath.section] as! MultipleOptionsAnswer)
            }
            else{
                cell.updateEmptyData()
            }
            
            return cell
        }
        
        // Return empty object.
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if self.selectedIndex == indexPath.section && isCollapsed {
            return 220
        }
        else{
            return 50
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if selectedIndex == indexPath.section {
            // Switch heights between selected rows.
            isCollapsed = !isCollapsed
        }else{
            // Collapse unselected rows.
            isCollapsed = true
        }
        
        self.selectedIndex = indexPath.section
                
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    // Make the background color show through.
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
    
    // Set the spacing between sections
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellPadding
    }
    
    // MARK: - Data saving and sending
    
    public func saveAnswer(index: Int, answer: Any) {
        let question = questions[index]
        
        if question is Short {
            let convertedAnswer = answer as! ShortAnswer
            answers.updateValue(convertedAnswer, forKey: index)
        }
        else if question is Paragraph {
            let convertedAnswer = answer as! ParagraphAnswer
            answers.updateValue(convertedAnswer, forKey: index)
        }
        else if question is Photo {
            let convertedAnswer = answer as! PhotoAnswer
            answers.updateValue(convertedAnswer, forKey: index)
        }
        else if question is Signature {
            let convertedAnswer = answer as! SignatureAnswer
            answers.updateValue(convertedAnswer, forKey: index)
        }
        else if question is MultipleOptions {
            let convertedAnswer = answer as! MultipleOptionsAnswer
            answers.updateValue(convertedAnswer, forKey: index)
        }
        
        alertDataSaved()
    }
    
    private func alertDataSaved() {
        let alert = UIAlertController(title: "Question saved successfully!", message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
        self.present(alert, animated: true)
    }
    
    @IBAction func sendAnswers(_ sender: Any) {
        // Return if no answers have been submited.
        if self.answers.count == 0 { return }
        
        let answersJSON = generateAnswersJson()
        presentAnswerRequestView(answerRequest: answersJSON)
    }
    
    @IBAction func clearAnswers(_ sender: Any) {
        // Clear the selected answers and the selected index.
        self.answers = [Int: Any]()
        self.selectedIndex = -1
        
        // Reset the table view.
        UIView.transition(with: self.questionnaireTableView,
                          duration: 0.35,
                          options: .transitionCrossDissolve,
                          animations: { self.questionnaireTableView.reloadData() })
    }

    // MARK: - JSON data reading and generation
    
    private func getQuestionsFromSampleJson() {
        if let url = Bundle.main.url(forResource: "sample", withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let object = try JSONSerialization.jsonObject(with: data, options: .allowFragments)
                if let dictionary = object as? [String: AnyObject] {
                    if let questions = dictionary["questions"] as? [Dictionary<String, Any>] {
                        for question in questions {
                            if let type = question["type"] as? String {
                                switch type {
                                case "short":
                                    self.questions.append(Short(title: question["title"] as! String))
                                    break
                                case "paragraph":
                                    self.questions.append(Paragraph(title: question["title"] as! String))
                                    break
                                case "photo":
                                    self.questions.append(Photo(title: question["title"] as! String))
                                    break
                                case "signature":
                                    self.questions.append(Signature(title: question["title"] as! String))
                                    break
                                case "single_option":
                                    self.questions.append(MultipleOptions(title: question["title"] as! String, availableOptions: question["available_options"] as! [String], allowsMultipleSelection: false))
                                    break
                                case "multiple_option":
                                    self.questions.append(MultipleOptions(title: question["title"] as! String, availableOptions: question["available_options"] as! [String], allowsMultipleSelection: true))
                                    break
                                default:
                                    print("Error in the question received...")
                                    break
                                }
                            }
                        }
                    }
                }
            } catch {
                print("Error!! Unable to parse Sample Data/sample.json")
            }
        }
    }
    
    private func generateAnswersJson() -> String {
        var answersArray = [String]()

        // Traverse the answers submitted and add them to the array.
        for answerResponse in self.answers {
            let answer = answerResponse.value
            
            var answerDic = Dictionary<String, String>()
            
            if answer is ShortAnswer {
                let convertedAnswer = answer as! ShortAnswer
                
                answerDic.updateValue("short", forKey: "type")
                answerDic.updateValue(convertedAnswer.questionTitle, forKey: "question")
                answerDic.updateValue(convertedAnswer.answer, forKey: "answer")
                
                answersArray.append(getJsonString(dic: answerDic))
            }
            else if answer is ParagraphAnswer {
                let convertedAnswer = answer as! ParagraphAnswer
                
                answerDic.updateValue("paragraph", forKey: "type")
                answerDic.updateValue(convertedAnswer.questionTitle, forKey: "question")
                answerDic.updateValue(convertedAnswer.answer, forKey: "answer")
                
                answersArray.append(getJsonString(dic: answerDic))
            }
            else if answer is PhotoAnswer {
                let convertedAnswer = answer as! PhotoAnswer
                
                answerDic.updateValue("photo", forKey: "type")
                answerDic.updateValue(convertedAnswer.questionTitle, forKey: "question")

                let imageAnswer: String = convertedAnswer.image.getBase64String()
                answerDic.updateValue(imageAnswer, forKey: "answer")
                
                answersArray.append(getJsonString(dic: answerDic))
            }
            else if answer is SignatureAnswer {
                let convertedAnswer = answer as! SignatureAnswer
                
                answerDic.updateValue("signature", forKey: "type")
                answerDic.updateValue(convertedAnswer.questionTitle, forKey: "question")
                
                let signatureImage = convertedAnswer.signature.getImage()
                let imageAnswer: String = signatureImage.getBase64String()
                answerDic.updateValue(imageAnswer, forKey: "answer")
                
                answersArray.append(getJsonString(dic: answerDic))
            }
            else if answer is MultipleOptionsAnswer {
                let convertedAnswer = answer as! MultipleOptionsAnswer
                                
                let type = convertedAnswer.allowsMultipleSelection ? "multiple_option" : "single_option"
                answerDic.updateValue(type, forKey: "type")
                answerDic.updateValue(convertedAnswer.questionTitle, forKey: "question")
                answerDic.updateValue(getJsonString(dic: convertedAnswer.answers), forKey: "answer")
                
                answersArray.append(getJsonString(dic: answerDic))
            }
        }
        
        // Genrate the last JSON value for the answers.
        var finalAnswersDic = Dictionary<String, [String]>()
        finalAnswersDic.updateValue(answersArray, forKey: "answers")
        
        return getJsonString(dic: finalAnswersDic)
    }
    
    // MARK: - JSON string convertion
    
    private func getJsonString(dic: Dictionary<String, String>) -> String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
    
    private func getJsonString(dic: [Int]) -> String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
    
    private func getJsonString(dic: Dictionary<String, [String]>) -> String {
        let encoder = JSONEncoder()
        if let jsonData = try? encoder.encode(dic) {
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        }
        return ""
    }
    
    // MARK: - Navigation movement
    
    private func presentAnswerRequestView(answerRequest: String) {
        let answerView : AnswerRequestViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "answerRequestVC") as! AnswerRequestViewController
        
        answerView.setRawAnswer(with: answerRequest)

        if let navCtrl = self.navigationController
        {
           navCtrl.pushViewController(answerView, animated: true)
        }
        else
        {
           let navCtrl = UINavigationController(rootViewController: answerView)
            self.present(navCtrl, animated: true, completion: nil)
        }
    }
}
