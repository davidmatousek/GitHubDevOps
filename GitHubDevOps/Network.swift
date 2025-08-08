//
//  Network.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/4/20.
//

import Foundation
import Apollo
import SwiftUI
class Network {
  @EnvironmentObject var viewer: GetViewer
    
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
    if let bearerToken = KeychainHelper.shared.getBearerToken() {
        headers["Authorization"] = "Bearer " + bearerToken
    }
    
    // Re-assign the updated headers to the request.
    request.allHTTPHeaderFields = headers

  }
}
