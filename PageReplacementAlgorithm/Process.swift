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
    
    // MARK: - Lifecycle
    
    init(id: Int, processTime: Int) {
        self.id = id
        self.processTime = processTime
        self.workedTime = 0
        self.isFinished = false
                
        MMU.shared.addProcess(self)
    }
    
    // MARK: - Public methods
    
    func run() {
        
        accessPage()
        processTime += 1
        if processTime == workedTime {
            freeMemory()
            isFinished = true
        }
    }
    
    // MARK: - Private methods
    
    private func accessPage() {
        
        guard Double.random > Constants.Process.pageAccessProbability else {
            return
        }
        
        Double.random < Constants.Process.pageModifyProbability
            ? MMU.shared.modifyPage()
            : MMU.shared.readPage()
    }
    
    private func freeMemory() {
        
        MMU.shared.freeMemory(for: self)
    }
}

// MARK: - Hashable

extension Process: Hashable {
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
//        hasher.combine(isFinished)
//        hasher.combine(workedTime)
//        hasher.combine(processTime)
    }
    
    static func == (lhs: Process, rhs: Process) -> Bool {
        return lhs.id == rhs.id
//            && lhs.isFinished == rhs.isFinished
//            && lhs.workedTime == rhs.workedTime
//            && lhs.processTime == rhs.processTime
    }
}
