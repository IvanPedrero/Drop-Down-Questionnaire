//
//  Extensions.swift
//  Custom Questionnaire
//
//  Created by Ivan Pedrero on 30/01/21.
//

import Foundation
import UIKit

extension UIView {
    
    /**
    Adds a border and a corner radius to the cell.
     */
    public func stylizeCell() {
        self.backgroundColor = UIColor.white
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        self.layer.cornerRadius = 8
        self.clipsToBounds = true
    }
    
    /**
     Scale the contents of a view to a defined valie.
     */
    func scale(by scale: CGFloat) {
        self.contentScaleFactor = scale
        for subview in self.subviews {
            subview.scale(by: scale)
        }
    }
}

extension DrawingCanvas {
    /**
     Gets and image from a view.
     */
    func getImage(scale: CGFloat? = nil) -> UIImage {
        let newScale = scale ?? UIScreen.main.scale
        self.scale(by: newScale)

        let format = UIGraphicsImageRendererFormat()
        format.scale = newScale

        let renderer = UIGraphicsImageRenderer(size: self.bounds.size, format: format)

        let image = renderer.image { rendererContext in
            self.layer.render(in: rendererContext.cgContext)
        }

        return image
    }
}

extension UITableView {
    func deselectAllRows(animated: Bool) {
        guard let selectedRows = indexPathsForSelectedRows else { return }
        for indexPath in selectedRows {
            deselectRow(at: indexPath, animated: animated)
        }
    }
}

extension UIImage {
    func tint(with color: UIColor) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(size, false, scale)
        defer { UIGraphicsEndImageContext() }
        color.set()
        withRenderingMode(.alwaysTemplate)
            .draw(in: CGRect(origin: .zero, size: size))
        return UIGraphicsGetImageFromCurrentImageContext()
    }
    
    func getBase64String()-> String {
        let imageData = self.pngData()! as NSData
        let base64 = imageData.base64EncodedData(options: .lineLength64Characters)
        return String(data: base64, encoding: .utf8)!
    }
}
