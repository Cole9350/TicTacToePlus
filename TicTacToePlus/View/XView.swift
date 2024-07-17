//
//  XView.swift
//  TicTacToePlus
//
//  Created by Shawn Cole on 7/15/24.
//

import UIKit

class XView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let strokeWidth: CGFloat = 12.0

        context.setLineWidth(strokeWidth)
        context.setStrokeColor(UIColor(.customGray).cgColor)
        context.setLineCap(.butt)
        
        let insetRect = rect.insetBy(dx: strokeWidth / 2, dy: strokeWidth / 2)
        context.move(to: CGPoint(x: insetRect.minX, y: insetRect.minY))
        context.addLine(to: CGPoint(x: insetRect.maxX, y: insetRect.maxY))
        context.strokePath()
        
        context.move(to: CGPoint(x: insetRect.maxX, y: insetRect.minY))
        context.addLine(to: CGPoint(x: insetRect.minX, y: insetRect.maxY))
        context.strokePath()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .clear
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        backgroundColor = .clear
    }
}
