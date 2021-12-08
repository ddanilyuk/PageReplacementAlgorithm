//
//  Constants.swift
//  PageReplacementAlgorithm
//
//  Created by Denys Danyliuk on 06.12.2021.
//

import Foundation

struct Constants {
    
    /// Period for running memory check
    static let memoryCheckPeriod = 40
    
    static let programTicks = 400
    
    // MARK: - MMU
    
    struct MMU {
        
        /// Number of pages in physical memory
        static let physicalMemoryPages = 12
        
        /// Number of pages in virtual memory
        static let virtualMemoryPages = 6
        
        /// Deviation of num of pages in virtual memory
        static let deviationVirtualPages = 1
    }
    
    // MARK: - Process
    
    struct Process {
        
        /// Initial number of processes
        static let numberOfProcess = 8
        
        /// Average process work time
        static let averageWorkTime = 36
        
        /// Process work time deviation
        static let deviationTime = 5
        
        /// Process quant duration
        static let quantDuration = 5
        
        ///  Probability to access page (read or modification)
        static let pageAccessProbability = 0.5
        
        /// Probability to modify page (else will be read)
        static let pageModifyProbability = 0.3
        
        /// Probability of new process appearance in each tick
        static let pageAppearProbability = 0.03
    }
    
    // MARK: - WorkingSet
    
    struct WorkingSet {
    
        /// Number of pages in working set
        static let pages = 2
        
        /// Probability of accessing a working set
        static let accessProbability = 0.9
        
        /// Working set time to live
        static let timeToLive = 25
    }
}
