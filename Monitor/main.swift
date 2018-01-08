//
//  main.swift
//  Monitor
//
//  Created by Michał Kałużny on 16/11/2016.
//
//

import Foundation



do {
    let rom = try Data.init(contentsOf: URL.init(fileURLWithPath: "/Users/maku/Downloads/Combat.bin"))
    let computer = Atari2600(rom: [UInt8](rom))
    
    try computer.reset()
    try computer.run()
} catch let error {
    dump(error)
    exit(1)
}
