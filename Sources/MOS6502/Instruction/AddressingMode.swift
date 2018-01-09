//
//  AddressingMode.swift
//  6502
//
//  Created by Michał Kałużny on 16/11/2016.
//
//

import Foundation

extension Instruction {
    enum AddressingMode {
        enum Error: Swift.Error {
            case addressingModeNotImplemented
            case invalidRegisterIndexed(register: CPU.Register)
        }
        
        case accumulator
        case immediate(data: UInt8)
        case implied
        case relative(data: UInt8)
        case absolute(data: UInt16)
        case zeroPage(data: UInt8)
        case indirect(data: UInt8)
        case indirectIndexed(data: UInt8, register: CPU.Register)
        case absoluteIndexed(data: UInt16, register: CPU.Register)
        case zeroPageIndexed(data: UInt8, register: CPU.Register)
        
        func value(with cpu: CPU, bus: Bus) throws -> UInt8 {
            switch self {
            case .immediate(let data):
                return data
            case .relative(let data):
                return data
            case _: throw Error.addressingModeNotImplemented
            }
        }
        
        func value(with cpu: CPU, bus: Bus) throws -> UInt16 {
            switch self {
            case .absolute(let data):
                return data
            case .zeroPageIndexed(let base, let register):
                switch register {
                case .X:
                    return UInt16(base &+ cpu.X)
                case .Y:
                    return UInt16(base &+ cpu.Y)
                case  _:
                    throw Error.invalidRegisterIndexed(register: register)
                }
            case .relative(let data):
                return UInt16(data)
            case _: throw Error.addressingModeNotImplemented
            }
        }
        
        var dataSize: UInt16 {
            switch self {
            case .absolute: return 2
            case .absoluteIndexed: return 1
            case .implied: return 0
            case .immediate: return 1
            case .indirect: return 1
            case .accumulator: return 0
            case .relative: return 1
            case .zeroPage: return 1
            case .indirectIndexed: return 1
            case .zeroPageIndexed: return 1
            }
        }
    }
}

extension Instruction.AddressingMode: CustomStringConvertible {
    var description: String {
        switch self {
        case .accumulator: return "A"
        case .implied: return ""
        case .immediate(let data): return "#$\(String(format: "%02x", data))"
        case .relative(let data): return "$\(String(format: "%02x", data))"
        case .zeroPage(let data): return "$\(String(format: "%02x", data))"
        case .indirect(let data): return "$\(String(format: "%02x", data))"
        case .absolute(let data): return "$\(String(format: "%04x", data))"
        case .indirectIndexed(let data, let register): return "$\(String(format: "%02x", data)), \(register)"
        case .absoluteIndexed(let data, let register): return "$\(String(format: "%04x", data)), \(register)"
        case .zeroPageIndexed(let data, let register): return "$\(String(format: "%02x", data)), \(register)"
        }
    }
}
