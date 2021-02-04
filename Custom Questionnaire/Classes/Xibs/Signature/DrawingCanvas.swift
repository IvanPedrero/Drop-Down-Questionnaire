//
//  DrawingCanvas.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 01/02/21.
//

import UIKit

class DrawingCanvas: UIView {
    
    struct Line {
        let strokeWidth: Float
        let color: UIColor
        var points: [CGPoint]
    }
    
    fileprivate var strokeColor = UIColor.black
    fileprivate var strokeWidth: Float = 1
    
    fileprivate var lines = [Line]()
    
    public var questionnaireTableView: UITableView = UITableView()
    
    public var hasSigned: Bool = false
    
    // MARK: - Drawing methods
    override func draw(_ rect: CGRect) {
        super.draw(rect)

        guard let context = UIGraphicsGetCurrentContext() else { return }

        lines.forEach { (line) in
            context.setStrokeColor(line.color.cgColor)
            context.setLineWidth(CGFloat(line.strokeWidth))
            context.setLineCap(.round)
            for (i, p) in line.points.enumerated() {
                if i == 0 {
                    context.move(to: p)
                } else {
                    context.addLine(to: p)
                }
            }
            context.strokePath()
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        lines.append(Line.init(strokeWidth: strokeWidth, color: strokeColor, points: []))
        print("Disabling scrolling...")
        questionnaireTableView.isScrollEnabled = false
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let point = touches.first?.location(in: self) else { return }
        
        guard var lastLine = lines.popLast() else { return }
        
        lastLine.points.append(point)
        lines.append(lastLine)
        
        setNeedsDisplay()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("Enabling scrolling...")
        questionnaireTableView.isScrollEnabled = true
        hasSigned = true
    }
    
    // MARK: - Configuration methods
    
    func setStrokeWidth(width: Float) {
        self.strokeWidth = width
    }

    func setStrokeColor(color: UIColor) {
        self.strokeColor = color
    }

    func clear() {
        lines.removeAll()
        setNeedsDisplay()
        hasSigned = false
    }


    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
