//
//  Network.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/4/20.
//

import Foundation
import Apollo
//class Network {
//  static let shared = Network()
//
//  private(set) lazy var apollo = ApolloClient(url: URL(string: "https://api.github.com/graphql")!)
//}
class Network {
  static let shared = Network()

  // Configure the network transport to use the singleton as the delegate.
  private lazy var networkTransport: HTTPNetworkTransport = {
    let transport = HTTPNetworkTransport(url: URL(string: "https://api.github.com/graphql")!)
    transport.delegate = self
    return transport
  }()

  // Use the configured network transport in your Apollo client.
  private(set) lazy var apollo = ApolloClient(networkTransport: self.networkTransport)
}
// MARK: - Pre-flight delegate

extension Network: HTTPNetworkTransportPreflightDelegate {

  func networkTransport(_ networkTransport: HTTPNetworkTransport,
                          shouldSend request: URLRequest) -> Bool {
    // If there's an authenticated user, send the request. If not, don't.
    return true
  }

  func networkTransport(_ networkTransport: HTTPNetworkTransport,
                        willSend request: inout URLRequest) {

    // Get the existing headers, or create new ones if they're nil
    var headers = request.allHTTPHeaderFields ?? [String: String]()

    // Add any new headers you need
    var keys: NSDictionary?
    if let path = Bundle.main.path(forResource: "Keys", ofType: "plist") {
           keys = NSDictionary(contentsOfFile: path)
       }
    if let dict = keys {
        let githubToken = (dict["GitHubToken"] as? String)!
        headers["Authorization"] = "Bearer " + githubToken
    }
    
    // Re-assign the updated headers to the request.
    request.allHTTPHeaderFields = headers

    //Logger.log(.debug, "Outgoing request: \(request)")
  }
}
