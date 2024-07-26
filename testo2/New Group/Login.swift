//
//  Login.swift
//  wallet
//
//  Created by Salar Pro on 6/17/24.
//

import SwiftUI


struct Login: View {
    @State var email = ""
    @State var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .padding()
                .background(Color.gray.opacity(0.2) )
                .cornerRadius(10)
            TextField("Password", text: $password)
                .padding()
                .background(Color.gray.opacity(0.2) )
                .cornerRadius(10)
            
            Button(action:  {
                Task {
                   
                }
            }) {
                Text("Login")
                    .foregroundColor(.white)
                    .padding(.vertical)
                    .frame(width: 200, height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            
        }
        .padding()
    }
    
}

#Preview {
    Login()
}
