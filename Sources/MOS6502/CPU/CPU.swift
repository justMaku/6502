//
//  CPU.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

public class CPU {
    enum Error: Swift.Error {
        case unimplementedOperation(opcode: Instruction.Opcode)
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
    public var PC: UInt16 = 0
    var  A: UInt8 = 0
    var  X: UInt8 = 0
    var  Y: UInt8 = 0
    var  SP: UInt8 = 0
    var  Status: Flags = []
    
    let bus: Bus
    
    public init(bus: Bus) {
        self.bus = bus
    }
    
    public func reset() throws {
        PC = try bus.read(from: 0xfffc)
        A = 0
        X = 0
        Y = 0
        SP = 0xFD
        Status = [.break]
    }
    
    public func step() throws {
        let operation = try fetch()
        try execute(operation: operation)
    }
    
    public func run() throws {
        while true {
            try step()
        }
    }
    
    func execute(operation: Instruction) throws {
        switch operation.mnemonic {
        case .SEI:
            Status.insert(.interrupt)
            PC += operation.size
        case .CLD:
            Status.remove(.decimal)
            PC += operation.size
        case .LDX:
            X = try operation.addressingMode.value(with: self, bus: bus)
            recalculateStatus(flags: [.zero, .negative], for: X)
            PC += operation.size
        case .LDA:
            A = try operation.addressingMode.value(with: self, bus: bus)
            recalculateStatus(flags: [.zero, .negative], for: A)
            PC += operation.size
        case .TXS:
            SP = X
            recalculateStatus(flags: [.zero, .negative], for: X)
            PC += operation.size
        case .TSX:
            X = try pop()
            PC += operation.size
        case .JSR:
            try push(PC + operation.size)
            PC = try operation.addressingMode.value(with: self, bus: bus)
        case .INX:
            X = X &+ 1
            recalculateStatus(flags: [.zero, .negative], for: X)
            PC += operation.size
        case .STA:
            let address: UInt16 = try operation.addressingMode.value(with: self, bus: bus)
            try bus.write(to: address, value: A)
            PC += operation.size
        case .BNE:
            if Status.contains(.zero) != true {
                var offset: UInt16 = try operation.addressingMode.value(with: self, bus: bus)
                
                if (offset & 0x80) != 0 {
                    offset |= 0xFF00;
                }
                
                PC = PC &+ UInt16(offset)
            } else {
                PC += operation.size
            }
        case .RTS:
            PC = try pop()
        case _:
            throw Error.unimplementedOperation(opcode: operation.opcode)
        }
    }
    
    private func fetch() throws -> Instruction {
        // definitely not optimal
        let data = try [PC, PC + 1, PC + 2].map { try bus.read(from: $0) as UInt8 }
        let stream = MemoryStream(storage: data)
        
        return try Instruction(stream: stream)
    }
}



