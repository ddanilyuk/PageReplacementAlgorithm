//
//  Kernel.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 08.12.2021.
//

import Foundation

final class Kernel {
    
    // MARK: - Singletone
    
    static let shared = Kernel()
    
    private init() { }
    
    // MARK: - Public methods
    
    func pageFault(
        for process: Process
    ) -> PhysicalPage {
        
        // Check for free page
        if let freePhysicalPage = MMU.shared.freePhysicalPages.first {
            MMU.shared.freePhysicalPages.removeFirst()
            Logger.shared.logFindPageFromFreeList(processId: process.id)
            return freePhysicalPage
        }
        
        // Check for unused and out of time to live page
        for physicalPage in MMU.shared.physicalPages {
            let virtualPage = physicalPage.virtualPage!
            let isReachedMaxTime = tick - physicalPage.tlu > Constants.WorkingSet.timeToLive
            if virtualPage.p && !virtualPage.r && isReachedMaxTime {
                Logger.shared.logFindPageReachedMaxTime(processId: process.id)
                return MMU.shared.evictPage(virtualPage: virtualPage, for: process)
            }
        }
        
        // Check for oldest page
        let oldestPhysicalPageUsed = MMU.shared.physicalPages.sorted { $0.tlu < $1.tlu }.first!
        if oldestPhysicalPageUsed.p, let virtualPage = oldestPhysicalPageUsed.virtualPage {
            Logger.shared.logFindOldestPage(processId: process.id, with: oldestPhysicalPageUsed.tlu)
            return MMU.shared.evictPage(virtualPage: virtualPage, for: process)
        } else {
            return oldestPhysicalPageUsed
        }
    }
    
    func generateVirtualMemory() -> [VirtualPage] {
        
        let minNumber = Constants.virtualMemoryPages - Constants.deviationVirtualPages
        let maxNumber = Constants.virtualMemoryPages + Constants.deviationVirtualPages
        let numberOfPages = Int.random(in: minNumber...maxNumber)
        return (0..<numberOfPages).map { _ in
            VirtualPage(p: false, r: false, m: false, physicalPage: nil)
        }
    }
}
