//
//  6502_CPUTests.swift
//  6502.CPUTests
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import XCTest
@testable import CPU

class CPUTests: XCTestCase {
    
    let entrypoint: UInt16 = 0x01ff
    
    override func setUp() {
        cpu = CPU()
        
        cpu.memory[0xfffc] = 0xff
        cpu.memory[0xfffd] = 0x01
    }
    
    var cpu: CPU!
    
    func testCPUReset() {
        
        cpu.reset()
        
        XCTAssertEqual(cpu.A, 0)
        XCTAssertEqual(cpu.X, 0)
        XCTAssertEqual(cpu.Y, 0)
        XCTAssertEqual(cpu.SP, 0xfd)
        XCTAssertEqual(cpu.Status, [.Carry])
        XCTAssertEqual(cpu.PC, entrypoint)
    }
    
    func test0xa9() {
        cpu.memory[entrypoint]     = 0xa9
        cpu.memory[entrypoint + 1] = 0xdb
        
        cpu.reset()
        try? cpu.step()
        
        XCTAssertEqual(cpu.A, 0xdb)
    }
}
