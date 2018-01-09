//
//  Types.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

public typealias Word = UInt8
public typealias DWord = UInt16

protocol Value {}

extension Word: Value {}
extension Double: Value {}

enum GenericError: Swift.Error {
    case Unimplemented
}
