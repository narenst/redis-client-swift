//
//  Redis.swift
//
//  Main file with the redis operations
//
//  Created by Naren Thiagarajan on 11/14/19.
//

import Foundation

class Redis {
    var connection: Connection
    
    init(host: String, port: Int) throws {
        do {
            self.connection = try Connection(host: host, port: port)
        }
        catch {
            print("Error creating the redis client: \(error)")
            throw error
        }
    }
    
    func process_bulk_string(resp: String) -> String {
        var prefix_num = ""
        var suffix_str = ""

        var found_break = false
        for char in resp {
            if char.isNumber {
                if found_break {
                    suffix_str.append(char)
                } else {
                    prefix_num.append(char)
                }
            }
            if char.isNewline {
                found_break = true
            }
        }
        return suffix_str
    }
    
    func process_response(resp: String) throws -> String? {
        let prefix = resp.prefix(1)
        
        let end_index = resp.index(resp.endIndex, offsetBy: -2)
        let range = resp.index(after: resp.startIndex)...end_index
        let content = String(resp[range])
        
        switch prefix {
        case "+":
            // Simple string
            return content
        case "-":
            // Error
            throw RedisException.ServerError(message: content)
        case ":":
            // Integer
            // TODO: Figure out how to return Int here
            return content
        case "$":
            // Bulk String
            if content == "-1" {
                // Null response
                return nil
            }
            return process_bulk_string(resp: content)
        case "*":
            // Array: This is not expected now
            return content
        default:
            throw RedisException.InvalidContentError(message: resp)
        }
    }
    
    func ping() throws -> String {
        let command = "PING\r\n"
        do {
            let _ = try self.connection.send_command(command: command)
            let response = try self.connection.read_response()
            return try self.process_response(resp: response)!
        }
        catch {
            throw error
        }
    }
    
    func get(key: String) throws -> String? {
        let command = "GET \(key)\r\n"
        do {
            let _ = try self.connection.send_command(command: command)
            let response = try self.connection.read_response()
            return try self.process_response(resp: response)
        }
        catch {
            throw error
        }
    }
    
    func set(key: String, value: String) throws -> String {
        let command = "SET \(key) \(value)\r\n"
        do {
            let _ = try self.connection.send_command(command: command)
            let response = try self.connection.read_response()
            return try self.process_response(resp: response)!
        }
        catch {
            throw error
        }
    }
}
