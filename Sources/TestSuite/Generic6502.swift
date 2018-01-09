//
//  Generic6502.swift
//  TestSuite
//
//  Created by Michał Kałużny on 09.01.18.
//

import Foundation
import MOS6502

class Generic6502: Bus {

    var memory: [UInt8]
    var cpu: CPU! = nil
    
    init(memory: [UInt8]) {
        self.memory = memory
        self.cpu = CPU(bus: self)
    }
    
    func run() throws {
        try cpu.run()
    }
    
    func reset() throws {
        try cpu.reset()
        cpu.PC = 0x400
    }
    
    func read(from address: UInt16) throws -> UInt8 {
        return memory[Int(address)]
    }
    
    func read(from address: UInt16) throws -> UInt16 {
        let low: UInt8 = try read(from: address)
        let high: UInt8 = try read(from: address + 1)
        
        return (UInt16(high) << 8 | UInt16(low))
    }
    
    func write(to address: UInt16, value: UInt8) throws {
        memory[Int(address)] = value
    }
}
