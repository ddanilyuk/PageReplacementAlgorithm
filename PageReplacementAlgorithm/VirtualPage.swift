//
//  VirtualPage.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

final class VirtualPage {
    
    let id = UUID()
    
    /// Presence bit
    var p: Bool
    
    /// Reference bit
    var r: Bool
    
    /// Modification bit
    var m: Bool
    
    /// Physical page num
    weak var physicalPage: PhysicalPage?
    
    // MARK: - Lifecycle
    
    init(
        p: Bool,
        r: Bool,
        m: Bool,
        physicalPage: PhysicalPage? = nil
    ) {
        self.p = p
        self.r = r
        self.m = m
        self.physicalPage = physicalPage
    }
}

// MARK: - Hashable

extension VirtualPage: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: VirtualPage, rhs: VirtualPage) -> Bool {
        return lhs.id == rhs.id
    }
}
