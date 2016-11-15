//
//  Map.swift
//  6502
//
//  Created by Michał Kałużny on 15/11/2016.
//
//

import Foundation

protocol Map {
    func translate(address: Double) -> Double
}
