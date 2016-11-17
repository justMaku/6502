//
//  CPU.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

class CPU {
    
    enum Error: Swift.Error {
        case UnimplementedOperation(opcode: Operation.Opcode)
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
        Status = [.carry]
    }
    
    func step() throws {
        let operation = try fetch()
        try execute(operation: operation)
    }
    
    func run() {
        
    }
    
    func execute(operation: Operation) throws {
        
    }
    
    private func fetch() throws -> Operation {
        // definitely not optimal
        let data = [PC, PC + 1, PC + 2].map { memory.read(address: $0) as Single }
        let stream = MemoryStream(storage: data)
        
        guard let operation = try? Operation(stream: stream) else {
            throw Error.UnimplementedOperation(opcode: data[0])
        }
        
        return operation
    }
}



