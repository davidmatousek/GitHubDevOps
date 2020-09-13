//
//  OrganizationView.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/10/20.
//

import SwiftUI

struct OrganizationView: View {
    var organization:Organization
    
    var body: some View {
        VStack {
            Text(organization.name)
                Form {
                    Section(header: Text("Repositories")) {

                        List(organization.repositories, id:\.id) { repository in
                        NavigationLink(destination: HomeDetailView(repository: repository)) {
                            Text(repository.name)
                                }
                        }
                    }
                }
        }
    }
}

struct OrganizationView_Previews: PreviewProvider {
    static var previews: some View {
        OrganizationView(organization: Organization.default)
    }
}
