//
//  Opcode.swift
//  6502
//
//  Created by Michał Kałużny on 16/11/2016.
//
//

import Foundation

private let mnemonicTable: [Operation.Mnemonic] = [
        /*        |  0  |  1  |  2  |  3  |  4  |  5  |  6  |  7  |  8  |  9  |  A  |  B  |  C  |  D  |  E  |  F  |      */
        /* 0 */    .BRK, .ORA, .NOP, .SLO, .NOP, .ORA, .ASL, .SLO, .PHP, .ORA, .ASL, .NOP, .NOP, .ORA, .ASL, .SLO, /* 0 */
        /* 1 */    .BPL, .ORA, .NOP, .SLO, .NOP, .ORA, .ASL, .SLO, .CLC, .ORA, .NOP, .SLO, .NOP, .ORA, .ASL, .SLO, /* 1 */
        /* 2 */    .JSR, .AND, .NOP, .RLA, .BIT, .AND, .ROL, .RLA, .PLP, .AND, .ROL, .NOP, .BIT, .AND, .ROL, .RLA, /* 2 */
        /* 3 */    .BMI, .AND, .NOP, .RLA, .NOP, .AND, .ROL, .RLA, .SEC, .AND, .NOP, .RLA, .NOP, .AND, .ROL, .RLA, /* 3 */
        /* 4 */    .RTI, .EOR, .NOP, .SRE, .NOP, .EOR, .LSR, .SRE, .PHA, .EOR, .LSR, .NOP, .JMP, .EOR, .LSR, .SRE, /* 4 */
        /* 5 */    .BVC, .EOR, .NOP, .SRE, .NOP, .EOR, .LSR, .SRE, .CLI, .EOR, .NOP, .SRE, .NOP, .EOR, .LSR, .SRE, /* 5 */
        /* 6 */    .RTS, .ADC, .NOP, .RRA, .NOP, .ADC, .ROR, .RRA, .PLA, .ADC, .ROR, .NOP, .JMP, .ADC, .ROR, .RRA, /* 6 */
        /* 7 */    .BVS, .ADC, .NOP, .RRA, .NOP, .ADC, .ROR, .RRA, .SEI, .ADC, .NOP, .RRA, .NOP, .ADC, .ROR, .RRA, /* 7 */
        /* 8 */    .NOP, .STA, .NOP, .SAX, .STY, .STA, .STX, .SAX, .DEY, .NOP, .TXA, .NOP, .STY, .STA, .STX, .SAX, /* 8 */
        /* 9 */    .BCC, .STA, .NOP, .NOP, .STY, .STA, .STX, .SAX, .TYA, .STA, .TXS, .NOP, .NOP, .STA, .NOP, .NOP, /* 9 */
        /* A */    .LDY, .LDA, .LDX, .LAX, .LDY, .LDA, .LDX, .LAX, .TAY, .LDA, .TAX, .NOP, .LDY, .LDA, .LDX, .LAX, /* A */
        /* B */    .BCS, .LDA, .NOP, .LAX, .LDY, .LDA, .LDX, .LAX, .CLV, .LDA, .TSX, .LAX, .LDY, .LDA, .LDX, .LAX, /* B */
        /* C */    .CPY, .CMP, .NOP, .DCP, .CPY, .CMP, .DEC, .DCP, .INY, .CMP, .DEX, .NOP, .CPY, .CMP, .DEC, .DCP, /* C */
        /* D */    .BNE, .CMP, .NOP, .DCP, .NOP, .CMP, .DEC, .DCP, .CLD, .CMP, .NOP, .DCP, .NOP, .CMP, .DEC, .DCP, /* D */
        /* E */    .CPX, .SBC, .NOP, .ISB, .CPX, .SBC, .INC, .ISB, .INX, .SBC, .NOP, .SBC, .CPX, .SBC, .INC, .ISB, /* E */
        /* F */    .BEQ, .SBC, .NOP, .ISB, .NOP, .SBC, .INC, .ISB, .SED, .SBC, .NOP, .ISB, .NOP, .SBC, .INC, .ISB  /* F */
]

extension Operation {
    enum Mnemonic: String {
        
        init(_ opcode: Single) {
            self = mnemonicTable[Int(opcode)]
        }
        
        init?(_ string: String) {
            guard let value = Mnemonic(rawValue: string) else {
                return nil
            }
            self = value
        }
        
        case ADC
        case AND
        case ASL
        case BCC
        case BCS
        case BEQ
        case BIT
        case BMI
        case BNE
        case BPL
        case BRK
        case BVC
        case BVS
        case CLC
        case CLD
        case CLI
        case CLV
        case CMP
        case CPX
        case CPY
        case DCP
        case DEC
        case DEX
        case DEY
        case EOR
        case INC
        case INX
        case INY
        case ISB
        case JMP
        case JSR
        case LAX
        case LDA
        case LDX
        case LDY
        case LSR
        case NOP
        case ORA
        case PHA
        case PHP
        case PLA
        case PLP
        case RLA
        case ROL
        case ROR
        case RRA
        case RTI
        case RTS
        case SBC
        case SEC
        case SED
        case SEI
        case SLO
        case SRE
        case SAX
        case STA
        case STX
        case STY
        case TAX
        case TAY
        case TSX
        case TXA
        case TXS
        case TYA
    }
}

extension Operation.Mnemonic: CustomStringConvertible {
    var description: String {
        return "\(self.rawValue)"
    }
}
