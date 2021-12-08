//
//  Extensions.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

// MARK: Double Extension

extension Double {
    
    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
    static var random: Double {
        return Double(arc4random()) / 0xFFFFFFFF
    }
}

//// MARK: Float Extension
//
//extension Float {
//
//    /// Returns a random floating point number between 0.0 and 1.0, inclusive.
//    static var random: Float {
//        return Float(arc4random()) / 0xFFFFFFFF
//    }
//}

extension Int {
    
    var string: String {
        return String(self)
    }
}

extension String {
    
    func padding(_ length: Int) -> String {
        return padding(toLength: length, withPad: " ", startingAt: 0)
    }
}

extension Collection {
    func choose(_ n: Int) -> ArraySlice<Element> { shuffled().prefix(n) }
}
