//
//  Viewer.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/9/20.
//

import Foundation
import SwiftUI

struct Viewer {
    
    var userName = ""
    var repositories = [Repository]()
    var organizations = [Organization]()
    
    static let `default` = Viewer(userName:"", repositories: [Repository](), organizations: [Organization]())
}

class GetViewer: ObservableObject {
    @Published var viewer: Viewer
    var bearerToken: String
    
    init(bearerToken: String) {
        print("running loadData")
        self.viewer = Viewer()
        self.bearerToken = bearerToken
        //fetchViewer()
    }
    
    func fetchViewer() {
            Network.shared.apollo.fetch(query: FetchViewerQuery()) { result in
              switch result {
              case .success(let graphQLResult):
                self.viewer.userName = graphQLResult.data!.viewer.name!
                for repository in graphQLResult.data!.viewer.repositories.nodes! {
                    if repository != nil {
                        //self.repositories.append(repository!.name)
                        //self.repositorieyArray.append(repository!)
                        var repo = Repository()
                        repo.id = repository!.id
                        repo.name = repository!.name
                        repo.pushedAt = repository!.pushedAt!
                        repo.hasProjectsEnabled = repository!.hasProjectsEnabled
                        repo.owner = repository!.owner.login
                        repo.description = repository!.description ?? ""
                        repo.forksTotalCount = repository!.forks.totalCount
                        repo.issuesTotalCount = repository!.issues.totalCount
                        repo.stargazersTotalCount = repository!.stargazers.totalCount
                        repo.watchersTotalCount = repository!.watchers.totalCount
                        repo.pullRequestsTotalCount = repository!.pullRequests.totalCount
                        self.viewer.repositories.append(repo)
                    }
                }
                for organization in
                    graphQLResult.data!.viewer.organizations.nodes! {
                    if organization != nil {
                        var org = Organization()
                        org.name = organization!.name ?? ""
                        
                        
                        
                        if let repositories = organization?.repositories.nodes {
                            for repository in repositories {
                                if repository != nil {
                                    var repo = Repository()
                                    repo.id = repository!.id
                                    repo.name = repository!.name
                                    repo.pushedAt = repository!.pushedAt!
                                    repo.hasProjectsEnabled = repository!.hasProjectsEnabled
                                    repo.owner = repository!.owner.login
                                    repo.description = repository!.description ?? ""
                                    repo.forksTotalCount = repository!.forks.totalCount
                                    repo.issuesTotalCount = repository!.issues.totalCount
                                    repo.stargazersTotalCount = repository!.stargazers.totalCount
                                    repo.watchersTotalCount = repository!.watchers.totalCount
                                    repo.pullRequestsTotalCount = repository!.pullRequests.totalCount
                                    org.repositories.append(repo)
                                }
                            }
                        }
                        self.viewer.organizations.append(org)
                    }
                    
                }
                            
                print("Success! Result: \(String(describing: self.viewer))")
              case .failure(let error):
                print("Failure! Error: \(error)")
              }
            }
        }

}
