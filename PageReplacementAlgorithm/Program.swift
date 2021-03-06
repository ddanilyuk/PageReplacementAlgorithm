//
//  Program.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

final class Program {
    
    // MARK: - Properties
    
    lazy var processes: [Process] = generateProcesses()
    var currentProcess: Process?
    
    // MARK: - Lifecycle
    
    func start() {
        
        Logger.shared.logStart(numberOfProcesses: processes.count)
        
        currentProcess = processes.first
        
        while tick != Constants.programTicks {
            runMemoryCheckIfNeeded()
            currentProcess?.run()
            changeProcessIfNeeded()
            tick += 1
        }
        
        Logger.shared.printStats()
    }
    
    // MARK: - Private methods
    
    private func generateProcesses() -> [Process] {
        
        let minProcessTime = Constants.Process.averageWorkTime - Constants.Process.deviationTime
        let maxProcessTime = Constants.Process.averageWorkTime + Constants.Process.deviationTime
        return (0..<Constants.Process.numberOfProcess).map {
            Process(id: $0, processTime: Int.random(in: minProcessTime...maxProcessTime))
        }
    }
    
    func runMemoryCheckIfNeeded() {
        
        if tick % Constants.memoryCheckPeriod == 0 {
            Logger.shared.logMemoryCheck()
            processes.forEach { $0.runMemoryCheck() }
        }
    }
    
    func changeProcessIfNeeded() {
        
        currentProcess = tick % Constants.Process.quantDuration == 0
            ? nextProcess()
            : currentProcess
    }
    
    func nextProcess() -> Process? {
        
        return processes.filter { !$0.isFinished }.randomElement()
    }
}
