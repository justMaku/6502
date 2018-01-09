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
    
    func read(from address: DWord) throws -> Word {
        return memory[Int(address)]
    }
    
    func read(from address: DWord) throws -> DWord {
        let low: Word = try read(from: address)
        let high: Word = try read(from: address + 1)
        
        return (DWord(high) << 8 | DWord(low))
    }
    
    func write(to address: DWord, value: Word) throws {
        memory[Int(address)] = value
    }
}
