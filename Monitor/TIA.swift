//
//  TIA.swift
//  Monitor
//
//  Created by Michał Kałużny on 08.01.18.
//

import Foundation
import MOS6502

struct TIA {
    enum Error: Swift.Error {
        case unusedReadRegister(address: Word)
        case unusedWriteRegister(address: Word)
    }
    
    // Write
    var CXCLR: Word = 0 // (clear collision latches)
    var HMCLR: Word = 0 // (clear horizontal motion registers)
    var HMOVE: Word = 0 // (apply horizontal motion)
    var RESMP1: Word = 0 // (reset missile 1 to player 1)
    var RESMP0: Word = 0 // (reset missile 0 to player 0)
    var VDELBL: Word = 0 // (vertical delay ball)
    var VDELP1: Word = 0 // (vertical delay player 1)
    var VDELP0: Word = 0 // (vertical delay player 0)
    var HMBL: Word = 0 // (horizontal motion ball)
    var HMM1: Word = 0 // (horizontal motion missile 1)
    var HMM0: Word = 0 // (horizontal motion missile 0)
    var HMP1: Word = 0 // (horizontal motion player 1)
    var HMP0: Word = 0 // (horizontal motion player 0)
    var ENABL: Word = 0 // (enable ball graphics)
    var ENAM1: Word = 0 // (enable missile 1 graphics)
    var ENAM0: Word = 0 // (enable missile 0 graphics)
    var GRP1: Word = 0 // (graphics player 1)
    var GRP0: Word = 0 // (graphics player 0)
    var AUDV1: Word = 0 // (audio volume 1)
    var AUDV0: Word = 0 // (audio volume 0)
    var AUDF1: Word = 0 // (audio frequency 1)
    var AUDF0: Word = 0 // (audio frequency 0)
    var AUDC1: Word = 0 // (audio control 1)
    var AUDC0: Word = 0 // (audio control 0)
    var RESBL: Word = 0 // (reset ball)
    var RESM1: Word = 0 // (reset missile 1)
    var RESM0: Word = 0 // (reset missile 0)
    var RESP1: Word = 0 // (reset player 1)
    var RESP0: Word = 0 // (reset player 0)
    var PF2: Word = 0 // (playfield register byte 2)
    var PF1: Word = 0 // (playfield register byte 1)
    var PF0: Word = 0 // (playfield register byte 0)
    var REFP1: Word = 0 // (reflect player 1)
    var REFP0: Word = 0 // (reflect player 0)
    var CTRLPF: Word = 0 // (control playfield ball size and reflect)
    var COLUBK: Word = 0 // (color-lum background)
    var COLUPF: Word = 0 // (color-lum playfield)
    var COLUP1: Word = 0 // (color-lum player 1)
    var COLUP0: Word = 0 // (color-lum player 0)
    var NUSIZ1: Word = 0 // (number-size player-missile 1)
    var NUSIZ0: Word = 0 // (number-size player-missile 0)
    var RSYNC: Word = 0 // (reset horizontal sync counter)
    var WSYNC: Word = 0 // (wait for leading edge of horizontal blank)
    var VBLANK: Word = 0 // (vertical blank set-clear)
    var VSYNC: Word = 0 // (vertical sync set-clear)
    
    // Read
    var INPT5: Word = 0 // (input port 5, trigger 1)
    var INPT4: Word = 0 // (input port 4, trigger 0)
    var INPT3: Word = 0 // (input port 3, pot 3)
    var INPT2: Word = 0 // (input port 2, pot 2)
    var INPT1: Word = 0 // (input port 1, pot 1)
    var INPT0: Word = 0 // (input port 0, pot 0)
    var CXPPMM: Word = 0 // (collision of players and missiles)
    var CXBLPF: Word = 0 // (collision of ball with playfield)
    var CXM1FB: Word = 0 // (collision of missile 1 with playfield-ball)
    var CXM0FB: Word = 0 // (collision of missile 0 with playfield-ball)
    var CXP1FB: Word = 0 // (collision of player 1 with playfield-ball)
    var CXP0FB: Word = 0 // (collision of player 0 with playfield-ball)
    var CXM1P: Word = 0 // (collision of missile 1 with players)
    var CXM0P: Word = 0 // (collision of missile 0 with players)
    
    func read(address: DWord) throws -> Word {
        let physicalAddress = Word(address & 0x0F) // Drop all but 4 left most bits
        switch physicalAddress {
        case 0x0D: return INPT5
        case 0x0C: return INPT4
        case 0x0B: return INPT3
        case 0x0A: return INPT2
        case 0x09: return INPT1
        case 0x08: return INPT0
        case 0x07: return CXPPMM
        case 0x06: return CXBLPF
        case 0x05: return CXM1FB
        case 0x04: return CXM0FB
        case 0x03: return CXP1FB
        case 0x02: return CXP0FB
        case 0x01: return CXM1P
        case 0x00: return CXM0P
        case _: throw Error.unusedWriteRegister(address: physicalAddress)
        }
    }
    
    mutating func write(address: DWord, value: Word) throws {
        let physicalAddress = Word(address & 0x3F) // Drop all but 6 left most bits
        switch physicalAddress {
        case 0x2C: self.CXCLR = value
        case 0x2B: self.HMCLR = value
        case 0x2A: self.HMOVE = value
        case 0x29: self.RESMP1 = value
        case 0x28: self.RESMP0 = value
        case 0x27: self.VDELBL = value
        case 0x26: self.VDELP1 = value
        case 0x25: self.VDELP0 = value
        case 0x24: self.HMBL = value
        case 0x23: self.HMM1 = value
        case 0x22: self.HMM0 = value
        case 0x21: self.HMP1 = value
        case 0x20: self.HMP0 = value
        case 0x1F: self.ENABL = value
        case 0x1E: self.ENAM1 = value
        case 0x1D: self.ENAM0 = value
        case 0x1C: self.GRP1 = value
        case 0x1B: self.GRP0 = value
        case 0x1A: self.AUDV1 = value
        case 0x19: self.AUDV0 = value
        case 0x18: self.AUDF1 = value
        case 0x17: self.AUDF0 = value
        case 0x16: self.AUDC1 = value
        case 0x15: self.AUDC0 = value
        case 0x14: self.RESBL = value
        case 0x13: self.RESM1 = value
        case 0x12: self.RESM0 = value
        case 0x11: self.RESP1 = value
        case 0x10: self.RESP0 = value
        case 0x0F: self.PF2 = value
        case 0x0E: self.PF1 = value
        case 0x0D: self.PF0 = value
        case 0x0C: self.REFP1 = value
        case 0x0B: self.REFP0 = value
        case 0x0A: self.CTRLPF = value
        case 0x09: self.COLUBK = value
        case 0x08: self.COLUPF = value
        case 0x07: self.COLUP1 = value
        case 0x06: self.COLUP0 = value
        case 0x05: self.NUSIZ1 = value
        case 0x04: self.NUSIZ0 = value
        case 0x03: self.RSYNC = value
        case 0x02: self.WSYNC = value
        case 0x01: self.VBLANK = value
        case 0x00: self.VSYNC = value
        case _: return // throw Error.unusedReadRegister(address: physicalAddress)
        }
    }
}
