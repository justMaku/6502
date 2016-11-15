//
//  Memory.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

protocol MemoryReadable {}

extension Single: MemoryReadable {}
extension Double: MemoryReadable {}

class Memory {
    var storage: [Single] = Array<Single>(repeating: 0x0, count: 0xFFFF)
   
    let map: Map
    
    init(map: Map) {
        self.map = map
    }
    
    func read(address: Double) -> Single {
        let address = map.translate(address: address)
        return storage[Int(address)]
    }
    
    func read(address: Double) -> Double {
        let lb = self.read(address: address) as Single
        let hb = self.read(address: address + 1) as Single
        
        return Double(lb) | Double(hb) << 8
    }
    
    func write(address: Double, value: Single) {
        storage[Int(address)] = value
    }
    
    subscript(address: Double) -> Single {
        get {
            return read(address: address)
        }
        
        set(new) {
            write(address: address, value: new)
        }
    }
}
