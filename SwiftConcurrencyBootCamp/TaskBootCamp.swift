//
//  TaskBootCamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Anh Dinh on 8/25/24.
//

import SwiftUI

class TaskBootCampViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var image2: UIImage? = nil
    
    func fetImage() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else {
                return
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image = UIImage(data: data)
        } catch {
            print("DEBUG: ERROR \(error.localizedDescription)")
        }
    }
    
    func fetImage2() async {
        do {
            guard let url = URL(string: "https://picsum.photos/200") else {
                return
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            self.image2 = UIImage(data: data)
        } catch {
            print("DEBUG: ERROR \(error.localizedDescription)")
        }
    }
}

struct TaskBootCammpHomeView: View {
    var body: some View {
        NavigationStack {
            NavigationLink("Click me 🤖") {
                TaskBootCamp()
            }
        }
    }
}

struct TaskBootCamp: View {
    @StateObject var viewModel = TaskBootCampViewModel()
    
    var body: some View {
        VStack {
            if let image = viewModel.image {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
            }
            
            if let image2 = viewModel.image2 {
                Image(uiImage: image2)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 200, height: 200)
            }
        }
        .task {
            // This does the same thing as what we do in .onAppear below
            // The good thing of this is that it automatically cancels the task
            // if the view having that task disappears.
            //
            // For some cases (check video), we have to handle the cancelation even we use
            // .task
        }
        .onAppear{
            //MARK: - Multi Task
            // 1. If we use 2 Task, we can execute them synchronously.
            // (They gonna look like executed at the same time)
            // We don't wait for the async func inside the Task to execute
            // If we put those 2 async funcs in 1 Task, the second one only runs when
            // the first one finished. (we can see the delay)
//            Task {
//                await viewModel.fetImage()
//            }
//            Task {
//                await viewModel.fetImage2()
//            }
            
            //MARK: - Task priority
            // Task with higher priority will be prioritized
            // Priority of a Task doesn't tell us if that Task finishes first
            // Chạy trước chưa chắc finish trước.
            // XCode will know and handle which one finishes first.
            // Để 2,3 thằng cho dễ thấy
            Task(priority: .low) {
                print("Low - \(Thread.current) - \(Task.currentPriority)")
            }
//            Task(priority: .medium) {
//                print("medium - \(Thread.current) - \(Task.currentPriority)")
//            }
            Task(priority: .background) {
                print("Background - \(Thread.current) - \(Task.currentPriority)")
            }
//            Task(priority: .utility) {
//                print("Utility - \(Thread.current) - \(Task.currentPriority)")
//            }
//            Task(priority: .userInitiated) {
//                print("UserInitiated - \(Thread.current) - \(Task.currentPriority)")
//            }
            Task(priority: .high) {
                print("High - \(Thread.current) - \(Task.currentPriority)")
            }

        }
    }
}

#Preview {
    TaskBootCamp()
}
