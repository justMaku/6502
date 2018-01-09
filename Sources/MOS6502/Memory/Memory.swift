//
//  Memory.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

protocol MemoryReadable {}

extension Word: MemoryReadable {}
extension DWord: MemoryReadable {}

public class Memory {
    var storage: [Word] = Array<Word>(repeating: 0x0, count: 0xFFFF)
   
    let map: MemoryMap
    
    public init(map: MemoryMap) {
        self.map = map
    }
    
    func read(address: DWord) -> Word {
        let address = map.translate(address: address)
        return storage[Int(address)]
    }
    
    func read(address: DWord) -> DWord {
        let lb = self.read(address: address) as Word
        let hb = self.read(address: address + 1) as Word
        
        return DWord(lb) | DWord(hb) << 8
    }
    
    func write(address: DWord, value: Word) {
        storage[Int(address)] = value
    }
    
    subscript(address: DWord) -> Word {
        get {
            return read(address: address)
        }
        
        set(new) {
            write(address: address, value: new)
        }
    }
}
