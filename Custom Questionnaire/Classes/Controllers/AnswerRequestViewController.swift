//
//  AnswerRequestViewController.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 03/02/21.
//

import UIKit

class AnswerRequestViewController: UIViewController {

    @IBOutlet weak var answersTexView: UITextView!
    @IBOutlet weak var formattedValueSwitch: UISwitch!
    
    private var rawAnswerString = String()
    private var formattedAnswerString = String()
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setAnswersContent()
    }
    
    public func setRawAnswer(with answer: String) {
        self.rawAnswerString = answer
    }
    
    // MARK: - Switch management
    
    @IBAction func onSwitchValueChanged(_ sender: Any) {
        if formattedValueSwitch.isOn {
            self.setFormattedAnswer()
        }
        else{
            self.setRawAnswer()
        }
    }
    
    // MARK: - Answer setting
    
    private func setAnswersContent() {
        let data = convertToDictionary(text: rawAnswerString)
        
        // Traverse the answers.
        if let answers = data!["answers"] as? NSArray {
            for answer in answers {
                // Append the dictionary to the string variable.
                self.formattedAnswerString += answer as? String ?? ""
                
                // Add a "," if not the last element.
                if answer as? String != answers[answers.count - 1] as? String {
                    self.formattedAnswerString += ",\n\n"
                }
            }
        }
        
        // Initially, set the formatted answer.
        setFormattedAnswer()
    }
    
    func convertToDictionary(text: String) -> [String: Any]? {
        if let data = text.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // MARK: - String switching
    
    private func setFormattedAnswer() {
        answersTexView.text = self.formattedAnswerString
    }

    private func setRawAnswer() {
        answersTexView.text = self.rawAnswerString
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
