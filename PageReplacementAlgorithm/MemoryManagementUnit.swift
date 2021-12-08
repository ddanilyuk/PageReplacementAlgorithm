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
    var busyPhysicalPages: [PhysicalPage] = []
        
    // MARK: - Singletone
    
    static let shared = MemoryManagementUnit()
    
    private init() {
        physicalPages = Array.init(
            repeating: PhysicalPage(p: false, vp: nil, tlu: 1),
            count: Constants.MMU.physicalMemoryPages
        )
        freePhysicalPages = physicalPages
    }
    
    // MARK: - Public methods
    
    func freeMemory(for process: Process) {
        
        Logger.shared.logFreeingMemory(processId: process.id, tick: tick)
        process.virtualPages.forEach { virtualPage in
            if virtualPage.p, let physicalPage = virtualPage.physicalPage {
                physicalPage.p = false
                physicalPage.virtualPage = nil
            }
        }
    }
    
    func runMemoryCheck() {
        
    }
    
    func readPage(for process: Process) {
        
        let virtualPageNumber = getAccessPageNumber(for: process)
        let virtualPage = process.virtualPages[virtualPageNumber]
        
        if !virtualPage.p {
            Logger.shared.logPageFault(processId: process.id, tick: tick)
            loadPageToMemory(virtualPage: virtualPage, for: process)
        }
        
        virtualPage.r = true
        Logger.shared.logPageRead(processId: process.id, tick: tick)
    }
    
    func modifyPage(for process: Process) {
        
        let virtualPageNumber = getAccessPageNumber(for: process)
        let virtualPage = process.virtualPages[virtualPageNumber]
        
        if !virtualPage.p {
            Logger.shared.logPageFault(processId: process.id, tick: tick)
            loadPageToMemory(virtualPage: virtualPage, for: process)
        }
        
        virtualPage.m = true
        virtualPage.r = true
        Logger.shared.logPageModification(processId: process.id, tick: tick)
    }
    
    // MARK: - Private methods
    
    // Move to somewhere
    
    private func getAccessPageNumber(for process: Process) -> Int {
        
        if Double.random < Constants.WorkingSet.accessProbability {
            Logger.shared.logWorkingSetPageAccess(processId: process.id, tick: tick)
            let enumeratedElement = Array(process.workingSet.enumerated()).randomElement()!
            return enumeratedElement.offset
            
        } else {
            Logger.shared.logNonWorkingSetPageAccess(processId: process.id, tick: tick)
            let enumeratedElement = Array(process.noneWorkingSet.enumerated()).randomElement()!
            return enumeratedElement.offset
        }
    }
    
    func evictPage(
        virtualPage: VirtualPage,
        for process: Process
    ) -> PhysicalPage {
        
        if virtualPage.m {
            Logger.shared.logDirtyPageWriteToDisc(processId: process.id, tick: tick)
        }
        
        guard let physicalPage = virtualPage.physicalPage else {
            fatalError("No physical page for this virtual page")
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
        
        let physicalPage = Kernel.shared.findFreePhysicalPage(for: process)
        
        physicalPage.p = true
        physicalPage.virtualPage = virtualPage
        
        virtualPage.p = true
        virtualPage.r = false
        virtualPage.m = false
        virtualPage.physicalPage = physicalPage
    }
}
