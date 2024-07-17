//
//  OView.swift
//  TicTacToePlus
//
//  Created by Shawn Cole on 7/15/24.
//

import UIKit

class OView: UIView {
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else { return }
        
        let strokeWidth: CGFloat = 10.0
        let radius = min(rect.size.width, rect.size.height) / 2 - strokeWidth / 2
        
        context.setLineWidth(strokeWidth)
        context.setStrokeColor(UIColor(.customGray).cgColor)
        
        context.addEllipse(in: CGRect(
            x: rect.midX - radius,
            y: rect.midY - radius,
            width: radius * 2,
            height: radius * 2))
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
