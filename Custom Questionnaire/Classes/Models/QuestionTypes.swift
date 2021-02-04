//
//  QuestionTypes.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 30/01/21.
//

import Foundation
import UIKit

// MARK: - Question types

public struct Short {
    var title = String()
}

public struct Paragraph {
    var title = String()
}

public struct Photo {
    var title = String()
}

public struct Signature {
    var title = String()
}

public struct MultipleOptions {
    var title = String()
    var availableOptions = [String]()
    var allowsMultipleSelection = Bool()
}

// MARK: - Answer types

public struct ShortAnswer {
    var questionTitle = String()
    var answer = String()
}

public struct ParagraphAnswer {
    var questionTitle = String()
    var answer = String()
}

public struct PhotoAnswer {
    var questionTitle = String()
    var image = UIImage()
}

public struct SignatureAnswer {
    var questionTitle = String()
    var signature = DrawingCanvas()
}

public struct MultipleOptionsAnswer {
    var questionTitle = String()
    var allowsMultipleSelection = Bool()
    var answers = [Int]()
}
