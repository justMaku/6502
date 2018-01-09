//
//  Map.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

public protocol MemoryMap {
    func translate(address: DWord) -> DWord
}
