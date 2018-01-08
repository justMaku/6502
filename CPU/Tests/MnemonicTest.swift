//
//  MnemonicTest.swift
//  6502
//
//  Created by Michał Kałużny on 17/11/2016.
//
//

import XCTest
@testable import CPU

class MnemonicTest: XCTestCase {
    func testUnknownOpcode() {
        let opcode: Word = 0x02
        XCTAssertThrowsError(try Operation.Mnemonic(opcode))
    }
    
    func testValidOpcode() {
        let opcode: Word = 0x00
        guard let mnemonic = try? Operation.Mnemonic(opcode) else {
            return XCTFail()
        }
        XCTAssertEqual(mnemonic, Operation.Mnemonic.BRK)
    }
    
    func testValidOpcodeFromString() {
        let opcode = "BRK"
        guard let mnemonic = try? Operation.Mnemonic(opcode) else {
            return XCTFail()
        }
        XCTAssertEqual(mnemonic, Operation.Mnemonic.BRK)
    }

    func testUnknownOpcodeFromString() {
        let opcode = "XXX"
        XCTAssertThrowsError(try Operation.Mnemonic(opcode))
    }

    func testMnemonicDescription() {
        let opcode: Word = 0x00
        guard let mnemonic = try? Operation.Mnemonic(opcode) else {
            return XCTFail()
        }
        XCTAssertEqual(mnemonic.description, "BRK")
    }
}
