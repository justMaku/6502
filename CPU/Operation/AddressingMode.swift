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
            case addressingModeNotImplemented
            case invalidRegisterIndexed(register: CPU.Register)
        }
        
        case accumulator
        case immediate(data: Word)
        case implied
        case relative(data: Word)
        case absolute(data: DWord)
        case zeroPage(data: Word)
        case indirect(data: Word)
        case indirectIndexed(data: Word, register: CPU.Register)
        case absoluteIndexed(data: DWord, register: CPU.Register)
        case zeroPageIndexed(data: Word, register: CPU.Register)
        
        func value(with cpu: CPU, bus: Bus) throws -> Word {
            switch self {
            case .immediate(let data):
                return data
            case .relative(let data):
                return data
            case _: throw Error.addressingModeNotImplemented
            }
        }
        
        func value(with cpu: CPU, bus: Bus) throws -> DWord {
            switch self {
            case .absolute(let data):
                return data
            case .zeroPageIndexed(let base, let register):
                switch register {
                case .X:
                    return DWord(base &+ cpu.X)
                case .Y:
                    return DWord(base &+ cpu.Y)
                case  _:
                    throw Error.invalidRegisterIndexed(register: register)
                }
            case .relative(let data):
                return DWord(data)
            case _: throw Error.addressingModeNotImplemented
            }
        }
    }
}

extension Operation.AddressingMode: CustomStringConvertible {
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
