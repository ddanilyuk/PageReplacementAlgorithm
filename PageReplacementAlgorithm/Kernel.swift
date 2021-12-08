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
    
    func findFreePhysicalPage(
        for process: Process
    ) -> PhysicalPage {
        
        // Check for free page
        if let freePhysicalPage = MMU.shared.freePhysicalPages.first {
            MMU.shared.freePhysicalPages.removeFirst()
            MMU.shared.busyPhysicalPages.append(freePhysicalPage)
            Logger.shared.logFindPageFromFreeList(processId: process.id)
            return freePhysicalPage
        }
        
        // Check for unused and out of time to live page
        for virtualPage in process.virtualPages {
            guard let physicalPage = virtualPage.physicalPage else {
                continue
            }
            let isReachedMaxTime = tick - physicalPage.tlu > Constants.WorkingSet.timeToLive
            if virtualPage.p && !virtualPage.r && isReachedMaxTime {
                Logger.shared.logFindPageReachedMaxTime(processId: process.id)
                return MMU.shared.evictPage(virtualPage: virtualPage, for: process)
            }
        }
        
        // Check for oldest page
        let oldestPhysicalPageUsed = MMU.shared.physicalPages.sorted(by: { $0.tlu < $1.tlu }).first!
        
        if oldestPhysicalPageUsed.p, let virtualPage = oldestPhysicalPageUsed.virtualPage {
            // I am not shore do i need to evict physical page using his virtualPage
            Logger.shared.logFindOldestPage(processId: process.id, with: oldestPhysicalPageUsed.tlu)
            return MMU.shared.evictPage(virtualPage: virtualPage, for: process)
        } else {
            return oldestPhysicalPageUsed
        }
    }
    
    func generateVirtualMemory(for process: Process) -> [VirtualPage] {
        
        let minNumber = Constants.MMU.virtualMemoryPages - Constants.MMU.deviationVirtualPages
        let maxNumber = Constants.MMU.virtualMemoryPages + Constants.MMU.deviationVirtualPages
        let numberOfPages = Int.random(in: minNumber...maxNumber)
        return (0..<numberOfPages).map { _ in
            VirtualPage(p: false, r: false, m: false, processId: process.id, physicalPage: nil)
        }
    }
}
