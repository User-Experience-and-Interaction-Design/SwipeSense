//
//  WebSocketServer.swift
//  DirectionalSwipe
//
//  Created by Neel Shah on 2024-11-12.
//


import Foundation
import Network

class WebSocketServer {
    private var listener: NWListener?
    var onToggleSwipe: (() -> Void)?

    func startServer(port: UInt16 = 8080) {
        let parameters = NWParameters.tcp
        parameters.allowLocalEndpointReuse = true
        listener = try? NWListener(using: parameters, on: NWEndpoint.Port(rawValue: port)!)

        listener?.newConnectionHandler = { [weak self] connection in
            connection.start(queue: .main)
            self?.receive(on: connection)
        }

        listener?.stateUpdateHandler = { state in
            switch state {
            case .ready:
                print("WebSocket server is ready on port \(port)")
            case .failed(let error):
                print("WebSocket server failed with error: \(error)")
            default:
                break
            }
        }

        listener?.start(queue: .main)
    }

    private func receive(on connection: NWConnection) {
        print("Waiting to receive a message...")
        connection.receiveMessage { [weak self] data, _, _, error in
            if let data = data, let message = String(data: data, encoding: .utf8) {
                print("Received message: \(message)")
                if message == "TOGGLE_SWIPE" {
                    self?.onToggleSwipe?()
                }
            }
            
            // Check for specific errors and ignore them
            if let error = error as? NWError {
                switch error {
                case .posix(let posixError) where posixError.rawValue == 96:
                    // Suppress "No message available on STREAM" error (POSIX code 96)
                    print("Connection closed gracefully by the sender.")
                case .posix(.ECONNRESET):
                    // Connection reset by peer; treat as EOF
                    print("Connection reset by peer.")
                default:
                    print("Receive error: \(error.localizedDescription)")
                }
            }
            
            // Continue to listen for new messages unless there was a critical error
            if error == nil || error == .posix(.ECONNRESET) {
                self?.receive(on: connection)
            }
        }
    }



    func stopServer() {
        listener?.cancel()
        listener = nil
    }
}
