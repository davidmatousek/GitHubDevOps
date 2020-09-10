//
//  RepositoryModel.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/9/20.
//

import Foundation

struct Repository {
    var id = ""
    var name = ""
    var pushedAt = ""
    var hasProjectsEnabled = false
    var owner = ""
    var description = ""
    var forksTotalCount = 0
    var issuesTotalCount = 0
    var stargazersTotalCount = 0
    var watchersTotalCount = 0
    var pullRequestsTotalCount = 0
    
    static let `default` = Repository(id: "", name: "", pushedAt: "", hasProjectsEnabled: false, owner: "", description: "", forksTotalCount: 0, issuesTotalCount: 0, stargazersTotalCount: 0, watchersTotalCount: 0, pullRequestsTotalCount: 0)
}
