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
    var avatarURL = ""
    var company = ""
    var email = ""
    var location = ""
    var twitterUsername = ""
    var repositories = [Repository]()
    var organizations = [Organization]()
    
    static let `default` = Viewer(userName:"", avatarURL:"", repositories: [Repository](), organizations: [Organization]())
    
    mutating func clearViewer() {
        self.userName = ""
        self.avatarURL = ""
        self.company = ""
        self.email = ""
        self.location = ""
        self.twitterUsername = ""
        self.repositories = [Repository]()
        self.organizations = [Organization]()
    }
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
            self.viewer.clearViewer()
            Network.shared.apollo.fetch(query: FetchViewerQuery()) { result in
              switch result {
              case .success(let graphQLResult):
                guard let data = graphQLResult.data else {
                    print("Error: No data in GraphQL response")
                    return
                }
                self.viewer.userName = data.viewer.name ?? ""
                self.viewer.avatarURL = data.viewer.avatarUrl
                self.viewer.company = data.viewer.company ?? ""
                self.viewer.email = data.viewer.email ?? ""
                self.viewer.location = data.viewer.location ?? ""
                self.viewer.twitterUsername = data.viewer.twitterUsername ?? ""
                if let repositories = data.viewer.repositories.nodes {
                    for repository in repositories {
                        if let repo_data = repository {
                            var repo = Repository()
                            repo.id = repo_data.id
                            repo.name = repo_data.name
                            repo.pushedAt = repo_data.pushedAt ?? ""
                            repo.hasProjectsEnabled = repo_data.hasProjectsEnabled
                            repo.owner = repo_data.owner.login
                            repo.description = repo_data.description ?? ""
                            repo.forksTotalCount = repo_data.forks.totalCount
                            repo.issuesTotalCount = repo_data.issues.totalCount
                            repo.stargazersTotalCount = repo_data.stargazers.totalCount
                            repo.watchersTotalCount = repo_data.watchers.totalCount
                            repo.pullRequestsTotalCount = repo_data.pullRequests.totalCount
                            self.viewer.repositories.append(repo)
                        }
                    }
                }
                if let organizations = data.viewer.organizations.nodes {
                    for organization in organizations {
                        if let org_data = organization {
                            var org = Organization()
                            org.name = org_data.name ?? ""
                            
                            if let repositories = org_data.repositories.nodes {
                                for repository in repositories {
                                    if let repo_data = repository {
                                        var repo = Repository()
                                        repo.id = repo_data.id
                                        repo.name = repo_data.name
                                        repo.pushedAt = repo_data.pushedAt ?? ""
                                        repo.hasProjectsEnabled = repo_data.hasProjectsEnabled
                                        repo.owner = repo_data.owner.login
                                        repo.description = repo_data.description ?? ""
                                        repo.forksTotalCount = repo_data.forks.totalCount
                                        repo.issuesTotalCount = repo_data.issues.totalCount
                                        repo.stargazersTotalCount = repo_data.stargazers.totalCount
                                        repo.watchersTotalCount = repo_data.watchers.totalCount
                                        repo.pullRequestsTotalCount = repo_data.pullRequests.totalCount
                                        org.repositories.append(repo)
                                    }
                                }
                            }
                            self.viewer.organizations.append(org)
                        }
                    }
                }
                            
                print("Success! Result: \(String(describing: self.viewer))")
              case .failure(let error):
                print("Failure! Error: \(error)")
              }
            }
        }
    
    func clearViewer() {
        self.viewer.clearViewer()
        self.bearerToken = ""
    }

}
