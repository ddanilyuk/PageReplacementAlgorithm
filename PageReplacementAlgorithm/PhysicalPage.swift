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
    
    /// Virtual page
    weak var virtualPage: VirtualPage?
    
    /// Tick of last use
    var tlu: Int
    
    // MARK: - Lifecycle
    
    init(p: Bool, vp: VirtualPage? = nil, tlu: Int? = nil) {
        self.p = p
        self.virtualPage = vp
        self.tlu = tlu ?? 0
    }
    
    // MARK: - Public methods
    
    /// Used for adding connection between `PhysicalPage` and `VirtualPage` and vice versa
    func setPresenceVirtualPage(_ virtualPage: VirtualPage) {
        self.virtualPage = virtualPage
        self.p = true
        self.virtualPage?.physicalPage = self
        self.virtualPage?.p = true
    }
    
    /// Used for removing connection between `PhysicalPage` and `VirtualPage` and vice versa
    func removePresenceVirtualPage() {
        self.virtualPage?.physicalPage = nil
        self.virtualPage?.p = false
        self.virtualPage = nil
        self.p = false
    }
}
