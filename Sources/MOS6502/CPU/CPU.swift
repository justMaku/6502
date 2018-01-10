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
    
    private func fetch() throws -> Instruction {
        return try Instruction(from: bus, PC: PC)
    }
}



