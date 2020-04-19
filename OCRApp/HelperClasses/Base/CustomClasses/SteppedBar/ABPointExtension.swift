//
//  ABPointExtension.swift
//  ABSteppedProgressBar
//

import UIKit


extension CGPoint {
    
    func distanceWith(_ p: CGPoint) -> CGFloat {
        return sqrt(pow(self.x - p.x, 2) + pow(self.y - p.y, 2))
    }

}
