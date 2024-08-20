//
//  DownloadImageAsync.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Anh Dinh on 8/20/24.
//

import SwiftUI

class DownloadImageAsyncImageLoader {
    let url = URL(string: "https://picsum.photos/200")!
    
    func handleResponse(data: Data?, response: URLResponse?) -> UIImage? {
        guard let data = data,
              let image = UIImage(data: data),
              let response = response as? HTTPURLResponse,
              response .statusCode >= 200 && response.statusCode < 300 else {
            return nil
        }
        
        return image
    }
    
    //MARK: - Watch video for @escaping and combine
    
    //MARK: - Using Async
    func downloadWithAsync() async throws -> UIImage? {
        do {
            let (data, response) = try await URLSession.shared.data(from: url, delegate: nil)
            return handleResponse(data: data, response: response)
        } catch {
            throw error
        }
    }
}

@MainActor
class DownloadImageAsyncViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    let loader = DownloadImageAsyncImageLoader()
    
    func fetchImage() async {
        // don't care about error,
        // if there's error, it will be nil
        self.image = try? await loader.downloadWithAsync()
    }
}

struct DownloadImageAsync: View {
    @StateObject var viewModel = DownloadImageAsyncViewModel()
    var body: some View {
        ZStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 250, height: 250)
            }
        }
        .onAppear{
            Task { await viewModel.fetchImage() }
        }
    }
}

#Preview {
    DownloadImageAsync()
}
