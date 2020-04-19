//
//  ABTextLayerExtension.swift
//  ABSteppedProgressBar
//


import UIKit

extension CATextLayer {
    
    func sizeWidthToFit() {
        let fontName = CTFontCopyPostScriptName(self.font as! CTFont) as String
        
        guard let string = self.string as? String, let font = UIFont(name: fontName, size: self.fontSize) else { return }
        
        let attributes = [NSAttributedStringKey.font: font]
        
        let attString = NSAttributedString(string: string, attributes: attributes)
        
        var ascent: CGFloat = 0, descent: CGFloat = 0, width: CGFloat = 0
        
        let line = CTLineCreateWithAttributedString(attString)
        
        width = CGFloat(CTLineGetTypographicBounds( line, &ascent, &descent, nil))

        width = ceil(width)
        
        self.bounds = CGRect(x: 0, y: 0, width: width, height: ceil(ascent+descent))
    }
}