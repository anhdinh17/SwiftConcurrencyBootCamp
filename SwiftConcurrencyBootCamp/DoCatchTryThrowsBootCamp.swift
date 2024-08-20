//
//  DoCatchTryThrowsBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Anh Dinh on 8/20/24.
//

import SwiftUI

class DoCatchTryThrowsBootCampManager {
    let isActive: Bool = true
    
    func getTitle() -> (title: String?, error: Error?) {
        if isActive {
            return ("NEW TEXT", nil)
        } else {
            return (nil, URLError(.badURL))
        }
    }
    
    // Another example is to use Result (Watch video)
    
    /// This func means if we can't return a String
    /// then we throw an error.
    func gettitle3() throws -> String {
//        if isActive {
//            return "New Text!!!!"
//        } else {
            throw URLError(.badServerResponse)
//        }
    }
    
    func getTitle4() throws -> String {
        if isActive {
            return "FINAL TEXT!!!!"
        } else {
            throw URLError(.badServerResponse)
        }
    }
}

class DoCatchTryThrowsBootCampViewModel: ObservableObject {
    @Published var text: String = "Starting Text"
    let manager = DoCatchTryThrowsBootCampManager()
    
    func fetchTitle() {
        /*
        let newTitle = manager.getTitle()
        if let newTitle = newTitle {
            self.text = newTitle
        }
         */
        
        //MARK: - Do - Catch
        // If one "try" gets error, it will stop immediately and will go
        // to catch block
        //
        // The exception is using try?
        // try? means we get nil if there's error
        // and codes keep going on, not jumping to catch block
        do {
            let newTitle = try? manager.gettitle3()
            self.text = newTitle ?? ""
            
            let finalTitle = try manager.getTitle4()
            self.text = finalTitle
        } catch {
            self.text = error.localizedDescription
        }
    }
}

struct DoCatchTryThrowsBootCamp: View {
    @StateObject var viewModel = DoCatchTryThrowsBootCampViewModel()
    
    var body: some View {
        Text(viewModel.text)
            .frame(width: 300, height: 300)
            .background(Color.blue)
            .onTapGesture {
                viewModel.fetchTitle()
            }
    }
}

#Preview {
    DoCatchTryThrowsBootCamp()
}
