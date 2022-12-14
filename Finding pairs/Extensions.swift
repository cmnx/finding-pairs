//
//  Extensions.swift
//  Finding pairs
//
//  Created by Constantin on 02.12.2022.
//

import UIKit

// MARK: - UIView identifier

extension UIView {
    static var identifier: String {
        return String(describing: self)
    }
}

extension Int {
    var rnd: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return -Int(arc4random_uniform(UInt32(abs(self))))
        } else {
            return 0
        }
    }
}




