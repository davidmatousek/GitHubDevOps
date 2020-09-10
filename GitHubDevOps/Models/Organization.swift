//
//  Organization.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/9/20.
//

import Foundation

struct Organization {
    var id = ""
    var name = ""
    var repositories = [Repository]()
    
    static let `default` = Organization(id: "", name: "", repositories: [Repository]())
}
