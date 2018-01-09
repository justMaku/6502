//
//  main.swift
//  TestSuite
//
//  Created by Michał Kałużny on 09.01.18.
//

import Foundation

do {
    guard CommandLine.argc > 1 else {
        print("usage: TestSuite suite.bin")
        exit(1)
    }
    let filePath = CommandLine.arguments[1]
    let fileURL = URL(fileURLWithPath: filePath)
    
    let rom = try Data.init(contentsOf: fileURL)
    let computer = Generic6502(memory: [UInt8](rom))
    
    try computer.reset()
    try computer.run()
} catch let error {
    print(error.localizedDescription)
    exit(1)
}
