//
//  Logger.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 07.12.2021.
//

import Foundation

final class Logger {
    
    // MARK: - Properties
    
    private var pageReads: Int = 0
    private var pageModifications: Int = 0
    private var pageFaults: Int = 0
    private var wroteDirtyPagesToDisk: Int = 0
    private var workingSetPageAccess: Int = 0
    private var nonWorkingSetPageAccess: Int = 0
    
    // MARK: - Singleton
    
    static let shared = Logger()
    
    private init() { }
    
    // MARK: - Public methods
    
    func printStats() {
        
        print("")
        print(Array.init(repeating: "*", count: 62).joined(separator: ""))
        print("")
        print("\("Total reads:".padding(40)) \(pageReads)")
        print("\("Total modifications:".padding(40)) \(pageModifications)")
        print("\("Total page faults:".padding(40)) \(pageFaults)")
        print("\("Total writes of dirty pages to disk:".padding(40)) \(wroteDirtyPagesToDisk)")
        print("\("Total working set page accesses:".padding(40)) \(workingSetPageAccess)")
        print("\("Total non working set page accesses:".padding(40)) \(nonWorkingSetPageAccess)")
        print("")
    }
    
    func logPageFault(processId: Int, tick: Int) {
        
        pageFaults += 1
        print("\("Page fault".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logPageRead(processId: Int, tick: Int) {
        
        pageReads += 1
        print("\("Page read".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logPageModification(processId: Int, tick: Int) {
        
        pageModifications += 1
        print("\("Page modification".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logDirtyPageWriteToDisc(processId: Int, tick: Int) {
        
        wroteDirtyPagesToDisk += 1
        print("\("Writing dirty page to disk".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logWorkingSetPageAccess(processId: Int, tick: Int) {
        
        workingSetPageAccess += 1
        print("\("Working set page access".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logNonWorkingSetPageAccess(processId: Int, tick: Int) {
        
        nonWorkingSetPageAccess += 1
        print("\("Non working set page access".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logReplacedUnusedPage(processId: Int, tick: Int) {
        
        print("\("Replaced unused page".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logReplacedOldestPage(processId: Int, tick: Int) {
        
        print("\("Replaced oldest page".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logUsedFreePage(processId: Int, tick: Int) {
        
        print("\("Used free page".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logFreeingMemory(processId: Int, tick: Int) {
        
        print("\("Process ended, freeing memory".padding(40)) | pid: \(processId.string.padding(2)) | tick: \(tick.string.padding(5))")
    }
    
    func logMemoryCheck() {
        
        print("\nMemory check and working set change:\n")
    }
}
