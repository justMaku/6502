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
        case unimplementedInstruction(instruction: Instruction)
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
        let instruction = try fetch()
        try execute(instruction: instruction)
    }
    
    public func run() throws {
        while true {
            try step()
        }
    }
    
    func execute(instruction: Instruction) throws {
        switch instruction.mnemonic {
        case .SEI:
            Status.insert(.interrupt)
            PC += instruction.size
        case .CLD:
            Status.remove(.decimal)
            PC += instruction.size
        case .LDX:
            X = try instruction.addressingMode.value(with: self, bus: bus)
            recalculateStatus(flags: [.zero, .negative], for: X)
            PC += instruction.size
        case .LDA:
            A = try instruction.addressingMode.value(with: self, bus: bus)
            recalculateStatus(flags: [.zero, .negative], for: A)
            PC += instruction.size
        case .TXS:
            SP = X
            recalculateStatus(flags: [.zero, .negative], for: X)
            PC += instruction.size
        case .TSX:
            X = try pop()
            PC += instruction.size
        case .JSR:
            try push(PC + instruction.size)
            PC = try instruction.addressingMode.value(with: self, bus: bus)
        case .INX:
            X = X &+ 1
            recalculateStatus(flags: [.zero, .negative], for: X)
            PC += instruction.size
        case .STA:
            let address: UInt16 = try instruction.addressingMode.value(with: self, bus: bus)
            try bus.write(to: address, value: A)
            PC += instruction.size
        case .BNE:
            if Status.contains(.zero) != true {
                var offset: UInt16 = try instruction.addressingMode.value(with: self, bus: bus)
                
                if (offset & 0x80) != 0 {
                    offset |= 0xFF00;
                }
                
                PC = PC &+ UInt16(offset)
            } else {
                PC += instruction.size
            }
        case .RTS:
            PC = try pop()
        case _:
            throw Error.unimplementedInstruction(instruction: instruction)
        }
    }
    
    private func fetch() throws -> Instruction {
        return try Instruction(from: bus, PC: PC)
    }
}



