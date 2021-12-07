//
//  VirtualPage.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

final class VirtualPage {
    
    /// Presence bit
    var p: Bool
    
    /// Reference bit
    var r: Bool
    
    /// Modification bit
    var m: Bool
    
    /// Physical page num
    var physicalPageNum: Int?
    
    // MARK: - Lifecycle
    
    init(
        p: Bool,
        r: Bool,
        m: Bool,
        physicalPageNum: Int? = nil
    ) {
        self.p = p
        self.r = r
        self.m = m
        self.physicalPageNum = physicalPageNum
    }
}
