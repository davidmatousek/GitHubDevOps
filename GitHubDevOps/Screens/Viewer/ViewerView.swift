//
//  ViewerView.swift
//  GitHubDevOps
//
//  Created by Matousek, David on 9/14/20.
//

import SwiftUI

struct ViewerView: View {
    @EnvironmentObject var viewer: GetViewer
    @Environment(\.presentationMode) var presentationMode
    @Binding var shouldPopToRootView : Bool
    
    var body: some View {
        VStack{
            HStack {
                if viewer.viewer.avatarURL != "" {
                    RemoteImage(url: viewer.viewer.avatarURL)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100)
                        .clipShape(/*@START_MENU_TOKEN@*/Circle()/*@END_MENU_TOKEN@*/)
                    }
            }
                .padding()
            Text(viewer.viewer.userName)
                .font(.title)
            Form {
                HStack {
                    Text("Company:")
                    Spacer()
                    Text(viewer.viewer.company)
                }
                HStack {
                    Text("Email:")
                    Spacer()
                    Text(viewer.viewer.email)
                }
                HStack {
                    Text("Location:")
                    Spacer()
                    Text(viewer.viewer.location)
                }
                HStack {
                    Text("Twitter:")
                    Spacer()
                    Text("@\(viewer.viewer.twitterUsername)")
                }
            }
            Button ("Log Out", action: {
                UserDefaults.standard.set("", forKey: "Bearer")
                self.shouldPopToRootView = false
                self.presentationMode.wrappedValue.dismiss()
                
            })
            .foregroundColor(.white)
            .padding(10)
            .background(Color.red)
            .clipShape(RoundedRectangle(cornerRadius: 10))
        }
        
    }
}

//struct ViewerView_Previews: PreviewProvider {
//    static var previews: some View {
//        ViewerView()
//    }
//}
