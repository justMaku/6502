//
//  BUS.swift
//  Monitor
//
//  Created by Michał Kałużny on 08.01.18.
//

import Foundation

public protocol Bus {
    func read(from address: DWord) throws -> Word
    func read(from address: DWord) throws -> DWord
    func write(to address: DWord, value: Word) throws
}
