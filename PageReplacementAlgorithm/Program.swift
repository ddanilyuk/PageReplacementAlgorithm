//
//  Program.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

final class Program {
    
    func start() {
        Logger.shared.logPageRead(processId: 1, tick: 1)
        Logger.shared.logPageFault(processId: 2, tick: 2)
        Logger.shared.logPageModification(processId: 2, tick: 2)
        Logger.shared.logDirtyPageWriteToDisc(processId: 2, tick: 2)
        Logger.shared.logWorkingSetPageAccess(processId: 2, tick: 2)
        Logger.shared.logNonWorkingSetPageAccess(processId: 2, tick: 2)
        Logger.shared.logReplacedUnusedPage(processId: 2, tick: 2)
        Logger.shared.logReplacedOldestPage(processId: 2, tick: 2)
        Logger.shared.logUsedFreePage(processId: 2, tick: 2)
        Logger.shared.logFreeingMemory(processId: 2, tick: 2)
        
        Logger.shared.printStats()
    }
}
