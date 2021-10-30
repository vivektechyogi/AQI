//
//  Service.swift
//  AQI
//
//  Created by Jai Mataji on 30/10/21.
//

import Foundation
import Starscream

class Service: NSObject{
    
    static let sharedInstance = Service()
    
    var socket: WebSocket!
    
    func startAQISocket(completion: @escaping([AQIModel]?, Error?)-> ()){
        var request = URLRequest(url: URL(string: "ws://city-ws.herokuapp.com/")!)
        request.timeoutInterval = 30
        socket = WebSocket(request: request)
        socket.connect()
        
        socket.onEvent = { event in
            switch event {
            case .connected(let headers):
              print("connected \(headers)")
            case .disconnected(let reason, let closeCode):
              print("disconnected \(reason) \(closeCode)")
            case .text(let text):
               let aqis =  [AQIModel].map(JSONString: text)
                completion(aqis, nil)
//                print("received text: \(aqis?.count) \(aqis?.last?.city) \(text)")
            case .binary(let data):
              print("received data: \(data)")
            case .pong(let pongData):
              print("received pong: \(pongData)")
            case .ping(let pingData):
              print("received ping: \(pingData)")
            case .error(let error):
              print("error \(error)")
            case .viabilityChanged:
              print("viabilityChanged")
            case .reconnectSuggested:
              print("reconnectSuggested")
            case .cancelled:
              print("cancelled")
            }
        }
    }
        
    func stopSocket(){
        if let _ = socket{
            socket.disconnect()
        }
    }
    
}
