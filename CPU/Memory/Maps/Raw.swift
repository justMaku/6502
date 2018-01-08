//
//  Raw.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

class Raw: MemoryMap {
    func translate(address: DWord) -> DWord {
        return address
    }
}
