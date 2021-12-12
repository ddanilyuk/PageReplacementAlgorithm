//
//  Process.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

final class Process {
    
    // MARK: - Properties
    
    /// Process ID
    let id: Int
    var processTime: Int
    var workedTime: Int
    var isFinished: Bool
    var virtualPages: [VirtualPage] = []
    var workingSet: Set<VirtualPage> = []
    var noneWorkingSet: Set<VirtualPage> = []
    
    // MARK: - Lifecycle
    
    init(id: Int, processTime: Int) {
        self.id = id
        self.processTime = processTime
        self.workedTime = 0
        self.isFinished = false
        
        virtualPages = Kernel.shared.generateVirtualMemory()
    }
    
    // MARK: - Public methods
    
    func run() {
        
        accessPage()
        workedTime += 1
        if processTime == workedTime {
            freeMemory()
            isFinished = true
        }
    }
    
    func runMemoryCheck() {
        
        guard !isFinished else {
            return
        }
        
        virtualPages.forEach { virtualPage in
            if virtualPage.r {
                virtualPage.r = false
                virtualPage.m = false
            }
        }
        generateWorkingSet()
    }
    
    // MARK: - Private methods
    
    private func accessPage() {
        
        guard Double.random < Constants.Process.pageAccessProbability else {
            return
        }
        
        guard let virtualPageToAccess = getVirtualPageToAccess() else {
            fatalError("At least one virtual page must exists")
        }
        
        Double.random < Constants.Process.pageModifyProbability
            ? MMU.shared.modifyPage(virtualPageToAccess, for: self)
            : MMU.shared.readPage(virtualPageToAccess, for: self)
    }
    
    private func getVirtualPageToAccess() -> VirtualPage? {
        
        if Double.random < Constants.WorkingSet.accessProbability {
            Logger.shared.logWorkingSetPageAccess(processId: id)
            return workingSet.randomElement()
            
        } else {
            Logger.shared.logNonWorkingSetPageAccess(processId: id)
            return noneWorkingSet.randomElement()
        }
    }
    
    private func freeMemory() {
        
        MMU.shared.freeMemory(for: self)
    }
    
    private func generateWorkingSet() {
        
        workingSet = Set(virtualPages.choose(Constants.WorkingSet.pages))
        noneWorkingSet = Set(virtualPages).subtracting(workingSet)
    }
}

// MARK: - Hashable

extension Process: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    static func == (lhs: Process, rhs: Process) -> Bool {
        return lhs.id == rhs.id
    }
}
