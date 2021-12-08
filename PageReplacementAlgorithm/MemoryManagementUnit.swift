//
//  MemoryManagementUnit.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

typealias MMU = MemoryManagementUnit

final class MemoryManagementUnit {
    
    // MARK: - Properties
    
    let physicalPages: [PhysicalPage]
    var freePhysicalPages: [PhysicalPage] = []
    
    // MARK: - Singletone
    
    static let shared = MemoryManagementUnit()
    
    private init() {
        physicalPages = (0..<Constants.MMU.physicalMemoryPages).map { _ in
            PhysicalPage(p: false, vp: nil, tlu: 1)
        }
        freePhysicalPages = physicalPages
    }
    
    // MARK: - Public methods
    
    func readPage(
        _ virtualPage: VirtualPage,
        for process: Process
    ) {
        if !virtualPage.p {
            Logger.shared.logPageFault(processId: process.id)
            loadPageToMemory(virtualPage: virtualPage, for: process)
        }
        
        virtualPage.r = true
        virtualPage.physicalPage?.tlu = tick
        Logger.shared.logPageRead(processId: process.id)
    }
    
    func modifyPage(
        _ virtualPage: VirtualPage,
        for process: Process
    ) {
        if !virtualPage.p {
            Logger.shared.logPageFault(processId: process.id)
            loadPageToMemory(virtualPage: virtualPage, for: process)
        }
        
        virtualPage.m = true
        virtualPage.r = true
        virtualPage.physicalPage?.tlu = tick
        Logger.shared.logPageModification(processId: process.id)
    }
    
    func freeMemory(for process: Process) {
        
        Logger.shared.logFreeingMemory(processId: process.id)
        process.virtualPages.forEach { virtualPage in
            if virtualPage.p, let physicalPage = virtualPage.physicalPage {
                physicalPage.p = false
                physicalPage.virtualPage = nil
                physicalPage.tlu = tick
                freePhysicalPages.append(physicalPage)
            }
        }
        process.virtualPages.removeAll()
    }
    
    // MARK: - Private methods
    
    func evictPage(
        virtualPage: VirtualPage,
        for process: Process
    ) -> PhysicalPage {
        
        if virtualPage.m {
            Logger.shared.logDirtyPageWriteToDisc(processId: process.id)
        }
        
        guard let physicalPage = virtualPage.physicalPage else {
            fatalError("Physical page must exists for this virtual page")
        }
        physicalPage.p = false
        physicalPage.virtualPage = nil
        
        virtualPage.p = false
        virtualPage.r = false
        virtualPage.m = false
        virtualPage.physicalPage = nil
        
        return physicalPage
    }
    
    private func loadPageToMemory(
        virtualPage: VirtualPage,
        for process: Process
    ) {
        
        let physicalPage = Kernel.shared.pageFault(for: process)
        
        physicalPage.p = true
        physicalPage.virtualPage = virtualPage
        
        virtualPage.p = true
        virtualPage.r = false
        virtualPage.m = false
        virtualPage.physicalPage = physicalPage
    }
}
