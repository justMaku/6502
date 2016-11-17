//
//  AddressingMode.swift
//  6502
//
//  Created by Michał Kałużny on 16/11/2016.
//
//

import Foundation

extension Operation {
    enum AddressingMode {
        
        enum Error: Swift.Error {
        }
        
        case Accumulator
        case Immediate(data: Single)
        case Implied
        case Relative(data: Single)
        case Absolute(data: Double)
        case ZeroPage(data: Single)
        case Indirect(data: Single)
        case IndirectIndexed(data: Single, register: CPU.Register)
        case AbsoluteIndexed(data: Double, register: CPU.Register)
        case ZeroPageIndexed(data: Single, register: CPU.Register)
        
        
        func address(with: Memory) throws -> Double {
            throw GenericError.Unimplemented
        }
    }
}

extension Operation.AddressingMode: CustomStringConvertible {
    var description: String {
        switch self {
        case .Accumulator: return "A"
        case .Implied: return ""
        case .Immediate(let data): return "#$\(String(format: "%02x", data))"
        case .Relative(let data): return "$\(String(format: "%02x", data))"
        case .ZeroPage(let data): return "$\(String(format: "%02x", data))"
        case .Indirect(let data): return "$\(String(format: "%02x", data))"
        case .Absolute(let data): return "$\(String(format: "%04x", data))"
        case .IndirectIndexed(let data, let register): return "$\(String(format: "%02x", data)), \(register)"
        case .AbsoluteIndexed(let data, let register): return "$\(String(format: "%04x", data)), \(register)"
        case .ZeroPageIndexed(let data, let register): return "$\(String(format: "%02x", data)), \(register)"
        }
    }
}
