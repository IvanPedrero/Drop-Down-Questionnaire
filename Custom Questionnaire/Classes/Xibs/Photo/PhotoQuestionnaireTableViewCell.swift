//
//  PhotoQuestionnaireTableViewCell.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 31/01/21.
//

import UIKit

class PhotoQuestionnaireTableViewCell: UITableViewCell, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    @IBOutlet weak var questionTitle: UILabel!
    @IBOutlet weak var answerImage: UIImageView!
    @IBOutlet weak var indicatorImage: UIImageView!
    
    private var questionnaireIndex = Int()
    private var questionnaireView = QuestionnaireViewController()
    
    var picker = UIImagePickerController();

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        picker.delegate = self
        addGestures()
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
    
    private func addGestures() {
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(onImageClick(tapGestureRecognizer:)))
        answerImage.isUserInteractionEnabled = true
        answerImage.addGestureRecognizer(tapGestureRecognizer)
    }
    
    @objc func onImageClick(tapGestureRecognizer: UITapGestureRecognizer)
    {
        switchImage()
    }
    
    @IBAction func onButtonClick(_ sender: Any) {
        saveData()
    }
    
    private func switchImage() {
        let alert = UIAlertController(title: "From where you want to choose the image?", message: nil, preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { action in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { action in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))

        self.questionnaireView.present(alert, animated: true)
    }
    
    private func saveData() {
        if answerImage.image == nil || answerImage.image == UIImage(systemName: "camera.viewfinder") { return }
        
        // Save data in global dict.
        let answer = PhotoAnswer(questionTitle: self.questionTitle.text!, image: answerImage.image!)
        self.questionnaireView.saveAnswer(index: questionnaireIndex, answer: answer)
        
        changeAnsweredIndicator(answered: true)
    }
    
    public func updateSavedData(answer: PhotoAnswer) {
        self.answerImage.image = answer.image
        changeAnsweredIndicator(answered: true)
    }
    
    public func updateEmptyData() {
        self.answerImage.image = UIImage(systemName: "camera.viewfinder")
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
    
    // MARK: - Picker delegate
    
    func openCamera(){
        if(UIImagePickerController .isSourceTypeAvailable(.camera)){
            picker.sourceType = .camera
            self.questionnaireView.present(picker, animated: true, completion: nil)
        } else {
            let alert = UIAlertController(title: "Warning", message: "You don't have a camera!", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Continue", style: .default, handler: nil))
            self.questionnaireView.present(alert, animated: true)
        }
    }
    func openGallery(){
        picker.sourceType = .photoLibrary
        self.questionnaireView.present(picker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion:nil)
        
        guard let image = info[.originalImage] as? UIImage else {
            fatalError("Expected a dictionary containing an image, but was provided the following: \(info)")
        }
        
        answerImage.image = image
    }
}
