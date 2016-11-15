//
//  CPU.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

class CPU {
    struct Flags: OptionSet {
        let rawValue: Single
        
        static let Sign = Flags(rawValue: 1 << 7)
        static let Overflow = Flags(rawValue: 1 << 6)
        static let Break = Flags(rawValue: 1 << 4)
        static let Decimal = Flags(rawValue: 1 << 3)
        static let Interrupt = Flags(rawValue: 1 << 2)
        static let Zero = Flags(rawValue: 1 << 1)
        static let Carry = Flags(rawValue: 1 << 0)
    }
    
    enum Register {
        case PC
        case A
        case X
        case Y
        case P
        case S
    }

    //MARK: Registers
    var PC: Double = 0
    var  A: Single = 0
    var  X: Single = 0
    var  Y: Single = 0
    var  SP: Single = 0
    var  Status: Flags = []
    
    let memory = Memory(map: Raw())
    
    func reset() {
        PC = memory.read(address: 0xfffc)
        A = 0
        X = 0
        Y = 0
        SP = 0xfd
        Status = [.Carry]
    }
    
    func step() throws {
        // definitely not optimal
        let data = [PC, PC + 1, PC + 2].map { memory.read(address: $0) as Single }
        let stream = MemoryStream(storage: data)
        
        guard let operation = try? Operation(stream: stream) else {
            return
        }
        
        try execute(operation: operation)
    }
    
    func run() {
        
    }
    
    func execute(operation: Operation) throws {
    }
}



