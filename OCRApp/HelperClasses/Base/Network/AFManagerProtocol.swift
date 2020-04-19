//
//  AFManagerProtocol.swift
//  BaseProject
//

import Foundation

public protocol AFManagerProtocol {
    func api(_ param: AFParam, completion: @escaping () -> Void)
}
