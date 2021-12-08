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
        generateWorkingSet()
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
        
        //        MMU.shared.r
    }
    
    // MARK: - Private methods
    

    
    private func accessPage() {
        
        guard Double.random > Constants.Process.pageAccessProbability else {
            return
        }
        
        Double.random < Constants.Process.pageModifyProbability
            ? MMU.shared.modifyPage(for: self)
            : MMU.shared.readPage(for: self)
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
