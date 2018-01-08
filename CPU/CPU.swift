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
        case unimplementedOperation(opcode: Operation.Opcode)
    }
    
    enum Register {
        case PC
        case A
        case X
        case Y
        case P
        case S
    }
    
    static let stackPointerBase: DWord = 0x100

    //MARK: Registers
    var PC: DWord = 0
    var  A: Word = 0
    var  X: Word = 0
    var  Y: Word = 0
    var  SP: Word = 0
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
    
    public func pop() throws -> Word {
        self.SP += 1
        
        let value: Word = try bus.read(from: DWord(self.SP) + CPU.stackPointerBase)
        
        return value
    }
    
    func pop() throws -> DWord {
        let low: Word = try pop()
        let high: Word = try pop()
        
        return DWord(low) | DWord(high) << 8
    }
    
    public func push(_ value: Word) throws {
        try self.bus.write(to: DWord(self.SP) + CPU.stackPointerBase, value: value)
        self.SP -= 1
    }
    
    public func push(_ value: DWord) throws {
        let low: Word = Word(value & 0xFF)
        let high: Word = Word(value >> 8) & 0xFF

        try self.push(high)
        try self.push(low)
    }
    
    func execute(operation: Operation) throws {
        switch operation.mnemonic {
        case .SEI:
            self.Status.insert(.interrupt)
            PC += 1
        case .CLD:
            self.Status.remove(.decimal)
            PC += 1
        case .LDX:
            self.X = try operation.addressingMode.value(with: self, bus: bus)
            recalculateStatus(flags: [.zero, .negative], for: self.X)
            PC += operation.size
        case .LDA:
            self.A = try operation.addressingMode.value(with: self, bus: bus)
            recalculateStatus(flags: [.zero, .negative], for: self.A)
            PC += operation.size
        case .TXS:
            self.SP = self.X
            recalculateStatus(flags: [.zero, .negative], for: self.X)
            PC += operation.size
        case .TSX:
            self.X = try pop()
            PC += operation.size
        case .JSR:
            try self.push(self.PC + 2)
            self.PC = try operation.addressingMode.value(with: self, bus: bus)
        case .INX:
            self.X = self.X &+ 1
            recalculateStatus(flags: [.zero, .negative], for: self.X)
            self.PC += operation.size
        case .STA:
            let address: DWord = try operation.addressingMode.value(with: self, bus: bus)
            try self.bus.write(to: address, value: self.A)
            self.PC += operation.size
        case .BNE:
            if self.Status.contains(.zero) != true {
                var offset: DWord = try operation.addressingMode.value(with: self, bus: bus)
                
                if (offset & 0x80) != 0 {
                    offset |= 0xFF00;
                }
                
                self.PC = self.PC &+ DWord(offset)
            } else {
                self.PC += operation.size
            }
        case .RTS:
            self.PC = try pop() + 1
        case _:
            throw Error.unimplementedOperation(opcode: operation.opcode)
        }
    }
    
    private func fetch() throws -> Operation {
        // definitely not optimal
        let data = try [PC, PC + 1, PC + 2].map { try bus.read(from: $0) as Word }
        let stream = MemoryStream(storage: data)
        
        return try Operation(stream: stream)
    }
}



