//
//  Flags.swift
//  6502
//
//  Created by Michał Kałużny on 17/11/2016.
//
//

import Foundation

extension CPU {
    struct Flags: OptionSet {
        let rawValue: Word
        
        static let negative = Flags(rawValue: 1 << 7)
        static let overflow = Flags(rawValue: 1 << 6)
        static let `break` = Flags(rawValue: 1 << 4)
        static let decimal = Flags(rawValue: 1 << 3)
        static let interrupt = Flags(rawValue: 1 << 2)
        static let zero = Flags(rawValue: 1 << 1)
        static let carry = Flags(rawValue: 1 << 0)
    }
    
    internal func recalculateStatus(flags: Flags, for value: Word) {
        if flags.contains(.carry) {
            calculateCarry(value: value)
        }
        
        if flags.contains(.overflow) {
            calculateCarry(value: value)
        }
        
        if flags.contains(.negative) {
            calculateSign(value: value)
        }
        
        if flags.contains(.zero) {
            calculateZero(value: value)
        }
    }
    
    private func calculateCarry(value: Word) {
        
    }
    
    private func calculateOverflow(value: Word) {
        
    }
    
    private func calculateSign(value: Word) {
        let bit = (value & (1 << 7)) != 0
        
        if bit {
            Status.insert(.negative)
        } else {
            Status.remove(.negative)
        }
    }
    
    private func calculateZero(value: Word) {
        if value != 0 {
            Status.remove(.zero)
        } else {
            Status.insert(.zero)
        }
    }
}
