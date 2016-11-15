//
//  Disassembler.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

class Disassembler {
    
    init(fileName: String) {
        let stream = InputStream(fileAtPath: fileName)!
        stream.open()
        print(fileName)
        repeat {
            if let operation = try? Operation(stream: stream) {
                print(operation)
            }
            
        } while stream.streamStatus != .atEnd
    }
    
}
