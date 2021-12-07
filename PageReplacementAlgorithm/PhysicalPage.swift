//
//  PhysicalPage.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

final class PhysicalPage {
    
    // MARK: - Properties
    
    /// Presence bit
    var p: Bool
    
    /// Virtual page number
    var vp: VirtualPage?
    
    /// Tick of last use
    var tlu: Int?
    
    // MARK: - Lifecycle
    
    init(p: Bool, vp: VirtualPage? = nil, tlu: Int? = nil) {
        self.p = p
        self.vp = vp
        self.tlu = tlu
    }
}
