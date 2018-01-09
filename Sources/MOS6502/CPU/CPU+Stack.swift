//
//  CPU+Stack.swift
//  MOS6502PackageDescription
//
//  Created by Michał Kałużny on 09.01.18.
//

import Foundation

extension CPU {
    internal func pop() throws -> UInt8 {
        self.SP += 1
        
        let value: UInt8 = try bus.read(from: UInt16(self.SP) + CPU.stackPointerBase)
        
        return value
    }
    
    internal func pop() throws -> UInt16 {
        let low: UInt8 = try pop()
        let high: UInt8 = try pop()
        
        return UInt16(low) | UInt16(high) << 8
    }
    
    internal func push(_ value: UInt8) throws {
        try self.bus.write(to: UInt16(self.SP) + CPU.stackPointerBase, value: value)
        self.SP -= 1
    }
    
    internal func push(_ value: UInt16) throws {
        let low: UInt8 = UInt8(value & 0xFF)
        let high: UInt8 = UInt8(value >> 8) & 0xFF
        
        try self.push(high)
        try self.push(low)
    }
}
