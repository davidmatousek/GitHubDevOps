//
//  ContentView.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/4/20.
//

import SwiftUI

extension String: Identifiable {
    public var id: String { self }
}

struct ContentView: View {
    //@ObservedObject private var repoData: RepositoriesListData = RepositoriesListData()
    @ObservedObject private var viewer: RepositoriesListData = RepositoriesListData()
    
    //private var users = [GetUsersQuery.Data.Viewer]()
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("User Information")) {
                    Text(viewer.viewer.userName)
                }
                Section(header: Text("Repositories")) {
//                    List(viewer.viewer.repositories, id:\.id) { repository in
//                        Text(repository.name)
//                    }
                    List(viewer.viewer.repositories, id:\.id) { repository in
                    NavigationLink(destination: DetailView(repository: repository)) {
                        Text(repository.name)
                            }
                    }
                                    }
                Section(header: Text("Metrics")) {
                    HStack {
                        Text("Number of Issues")
                        Spacer()
                        Text("5")
                    }
                    
                }
            }
            .navigationBarTitle("My Repositories")
           
        }
    }
}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
struct Viewer {
    var userName = ""
    var repositories = [Repository]()
}

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

    
class RepositoriesListData: ObservableObject {
    @Published var repositories: [String]
    @Published var repositorieyArray: [GetUsersRepositoriesQuery.Data.Viewer.Repository.Node]
    @Published var viewer: Viewer
    
    init() {
        print("running loadData")
        self.repositories  = [String]()
        self.repositorieyArray = [GetUsersRepositoriesQuery.Data.Viewer.Repository.Node]()
        self.viewer = Viewer()
        
        loadData()
    }
    func loadData() {
            Network.shared.apollo.fetch(query: GetUsersRepositoriesQuery()) { result in
              switch result {
              case .success(let graphQLResult):
                self.viewer.userName = graphQLResult.data!.viewer.name!
                for repository in graphQLResult.data!.viewer.repositories.nodes! {
                    if repository != nil {
                        self.repositories.append(repository!.name)
                        self.repositorieyArray.append(repository!)
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
                            
                print("Success! Result: \(String(describing: self.repositories))")
              case .failure(let error):
                print("Failure! Error: \(error)")
              }
            }
        }

}
