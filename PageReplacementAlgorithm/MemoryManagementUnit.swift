//
//  MemoryManagementUnit.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

typealias MMU = MemoryManagementUnit

var tick: Int = 0

final class MemoryManagementUnit {
    
    
    // MARK: - Properties
    
    let physicalPages: [PhysicalPage]
    var freePhysicalPages: [Int] = []
    var busyPhysicalPages: [Int] = []
    
    // ?
    var virtualMemory: [Process: [VirtualPage]] = [:]
    
    // MARK: - Singletone
    
    static let shared = MemoryManagementUnit()
    
    private init() {
        physicalPages = Array.init(
            repeating: PhysicalPage(p: false, vp: nil, tlu: 1),
            count: Constants.MMU.physicalMemoryPages)
    }
    
    // MARK: - Public methods
    
    func addProcess(_ process: Process) {
        
        virtualMemory[process] = generateVirtualMemory()
    }
    
    func freeMemory(for process: Process) {
        
        Logger.shared.logFreeingMemory(processId: process.id, tick: tick)
        virtualMemory[process]?.forEach { virtualPage in
            if virtualPage.p, let physicalPageNum = virtualPage.physicalPageNum {
                physicalPages[physicalPageNum].p = false
            }
        }
    }
    
    func runMemoryCheck() {
        
    }
    
    func readPage() {
        
    }
    
    func modifyPage() {
        
    }
    
    // MARK: - Private methods
    
    private func generateVirtualMemory() -> [VirtualPage] {
        
        let minNumber = Constants.MMU.virtualMemoryPages - Constants.MMU.deviationVirtualPages
        let maxNumber = Constants.MMU.virtualMemoryPages + Constants.MMU.deviationVirtualPages
        let numberOfPages = Int.random(in: minNumber...maxNumber)
        return Array.init(
            repeating: VirtualPage(p: false, r: false, m: false, physicalPageNum: nil),
            count: Int.random(in: 0...numberOfPages)
        )
    }
    
    private func findFreePPN() -> Int {
        
        
        return 0
    }
    
    private func getAccessPageNum(for process: Process) -> Int {
        
        if Double.random < Constants.WorkingSet.accessProbability {
            Logger.shared.logWorkingSetPageAccess(processId: process.id, tick: tick)
            
        } else {
            
        }
        
        return 0
    }
    
    private func evictPage(virtualPage: VirtualPage) {
        
    }
    
    private func loadPageToMemory(virtualPageNumber: Int) {
        
    }
    

    

    
    
}
