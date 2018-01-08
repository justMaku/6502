//
//  2600.swift
//  Monitor
//
//  Created by Michał Kałużny on 08.01.18.
//

import Foundation
import MOS6502

class Atari2600: MOS6502.Bus {
    struct RIOT {
        var ram: [UInt8] = Array<UInt8>(repeating: 0, count: Int(Atari2600.ramSize))
        
        func read(from address: DWord) throws -> Word {
            if (address & (1 << 9)) == 0 { // 9nth bit is RAM select bit
                let physicalAddress = address & 0b1111111
                return ram[Int(physicalAddress)]
            } else {
                throw Error.readFromUnknownPhysicalMemory(physicalAddress: address)
            }
        }
        
        mutating func write(address: DWord, value: Word) throws {
            if (address & (1 << 9)) == 0 { // 9nth bit is RAM select bit
                let physicalAddress = address & 0b1111111
                ram[Int(physicalAddress)] = value
            } else {
                throw Error.writeToUnknownPhysicalMemory(physicalAddress: address)
            }
        }
    }
    
    enum Error: Swift.Error {
        case readFromUnknownPhysicalMemory(physicalAddress: DWord)
        case writeToUnknownPhysicalMemory(physicalAddress: DWord)
        case writeToUnwriteableMemory(physicalAddress: DWord)
    }

    
    static let romStart: DWord = 0x1000
    static let romSize: DWord = 0x1000
    static let romEnd: DWord = romStart + romSize
    
    static let ramStart: DWord = 0x80
    static let ramSize: DWord = 0x80
    static let ramEnd: DWord = ramStart + ramSize
    
    
    let rom: [UInt8]
    
    
    var cpu: CPU! = nil
    var riot: RIOT = .init()
    var tia: TIA = .init()
    
    init(rom: [UInt8]) {
        self.rom = rom
        self.cpu = CPU(bus: self)
    }
    
    func run() throws {
        try cpu.run()
    }
    
    func reset() throws {
        try cpu.reset()
    }
    
    func read(from address: DWord) throws -> Word {
        let physicalAddress = translate(address)
        
        // Chip Select
        let A12 = physicalAddress & (1 << 12) != 0
        let A7  = physicalAddress & (1 <<  7) != 0
        
        switch (A12, A7) {
        case (true, _): // ROM
            return rom[Int(physicalAddress - Atari2600.romStart)]
        case (false, true): // RIOT
            return try riot.read(from: address)
        case (false, false):
            return try tia.read(address: physicalAddress)
        }
    }
    
    func read(from address: DWord) throws -> DWord {
        let physicalAddress = translate(address)
        let low: Word = try read(from: physicalAddress)
        let high: Word = try read(from: physicalAddress + 1)
        
        return (DWord(high) << 8 | DWord(low))
    }
    
    
    func write(to address: DWord, value: Word) throws {
        let physicalAddress = translate(address)
        
        // Chip Select
        let A12 = physicalAddress & (1 << 12) != 0
        let A7  = physicalAddress & (1 <<  7) != 0
        
        switch (A12, A7) {
        case (true, _): // ROM
            throw Error.writeToUnwriteableMemory(physicalAddress: address)
        case (false, true): // RIOT
            return try riot.write(address: physicalAddress, value:value)
        case (false, false):
            return try tia.write(address: physicalAddress, value: value)
        }
    }
    
    static let maximumAdressableMemory: DWord = 0x1000
    func translate(_ address: DWord) -> DWord {
        // 2600 doesn't really use a 6502, but 6507 instead
        // The difference is in the amount of memory that the CPU can access
        // While still technically running on a 16-bit bus, only the lower 13 bits
        // are wired, so instead of full 0xFFFF, highest address accessible is 0x1FFF
        // We need to drop those higher 3 bits anytime we access any part of the memory
        // which in practice means that memory is being mirrored, i.e:
        // 0x2FF0 == 0x1FF0
        
        return address & 0b1111111111111;
    }
}
