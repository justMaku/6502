//
//  CPU+Instructions.swift
//  MOS6502PackageDescription
//
//  Created by Michał Kałużny on 09.01.18.
//

import Foundation

extension CPU {
    internal func execute(instruction: Instruction) throws {
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
        case .LDY:
            Y = try instruction.addressingMode.value(with: self, bus: bus)
            recalculateStatus(flags: [.zero, .negative], for: Y)
            PC += instruction.size
        case .TXS:
            SP = X
            recalculateStatus(flags: [.zero, .negative], for: X)
            PC += instruction.size
        case .TSX:
            X = try pop()
            PC += instruction.size
        case .JSR:
            PC += instruction.size
            try push(PC)
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
            PC += instruction.size

            if Status.contains(.zero) != true {
                PC = try instruction.addressingMode.value(with: self, bus: bus)
            }
        case .BEQ:
            PC += instruction.size

            if Status.contains(.zero) == true {
                PC = try instruction.addressingMode.value(with: self, bus: bus)
            }
        case .RTS:
            PC += instruction.size
            PC = try pop()
        case .DEX:
            X = X &- 1
            recalculateStatus(flags: [.zero, .negative], for: X)
            PC += instruction.size
        case .DEY:
            Y = Y &- 1
            recalculateStatus(flags: [.zero, .negative], for: Y)
            PC += instruction.size
        case .JMP:
            PC = try instruction.addressingMode.value(with: self, bus: bus)
        case _:
            throw Error.unimplementedInstruction(instruction: instruction)
        }
    }
}
