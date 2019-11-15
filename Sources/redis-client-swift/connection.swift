//
//  Connection.swift
//  
//
//  Created by Naren Thiagarajan on 11/14/19.
//

import Foundation
import Socket

class Connection {
//    var host: String
//    var port: Int
//    var timeout_seconds: Int
    var socket: Socket?
    
    init(host: String, port: Int, timeout_seconds: Int = 1) throws {
        do {
            self.socket = try Socket.create()
            try self.socket?.connect(to: host, port: Int32(port))
        } catch let error as Socket.Error {
            throw RedisException.ConnectionError(message: error.errorReason!)
        } catch {
            throw RedisException.ConnectionError(message: error.localizedDescription)
        }
    }
    
    func send_command(command: String) throws -> Bool {
        do {
            try self.socket?.write(from: command)
            return true
        } catch let error as Socket.Error {
            throw RedisException.ConnectionError(message: error.errorReason!)
        } catch {
            throw RedisException.ConnectionError(message: error.localizedDescription)
        }
    }
    
    func read_response() throws -> String {
        do {
            let response = try self.socket?.readString()
            return response!
        } catch let error as Socket.Error {
            throw RedisException.ConnectionError(message: error.errorReason!)
        } catch {
            throw RedisException.ConnectionError(message: error.localizedDescription)
        }
    }
}
