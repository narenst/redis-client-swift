//
//  Exceptions.swift
//  
//
//  Created by Naren Thiagarajan on 11/14/19.
//

import Foundation

enum RedisException: Error {
    case ConnectionError(message: String?)
    case ServerError(message: String?)
    case InvalidContentError(message: String?)
}
