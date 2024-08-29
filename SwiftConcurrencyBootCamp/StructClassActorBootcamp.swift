//
//  StructClassActorBootcamp.swift
//  SwiftConcurrencyBootCamp
//
//  Created by Anh Dinh on 8/28/24.
//

import SwiftUI

class StructClassActorBootcampViewModel: ObservableObject {
    @Published var title: String = ""
    
    init(){
        print("ViewModel Init")
    }
}

struct StructClassActorBootcampHomeView: View {
    @State private var isActive: Bool = false
    
    init() {
        print("HomeView init")
    }
    
    var body: some View {
        // Phải setup kiểu này và để onTapGetsure của BootCampView ở đây
        // Thì init() của BootCampView mới chạy lại mỗi lần re-render
        StructClassActorBootcamp(isActive: isActive)
            .onTapGesture {
                isActive.toggle()
            }
    }
}

struct StructClassActorBootcamp: View {
    @StateObject private var viewModel = StructClassActorBootcampViewModel()
    
    @State var isActive: Bool = false
    
    init(isActive: Bool) {
        self.isActive = isActive
        print("View init")
    }
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(isActive ? Color.red : Color.blue )
            .onAppear{
//                runTest()
            }
    }
}

//#Preview {
//    StructClassActorBootcamp(isActive: true)
//}

extension StructClassActorBootcamp {
    private func runTest() {
        print("Test started")
//        structTest1()
        structTest2()
        printDivider()
        classTest2()
    }
    
    func printDivider() {
        print("""
        --------------------
        """)
    }
    
    private func structTest1() {
        let objectA = MyStruct(title: "Starting Text")
        
        // Creating objectB is like creating a new MyStruct struct
        // and pass data from objectA to it.
        var objectB = objectA
        print("Object A", objectA.title)
        print("Object B", objectB.title)
        
        // ojbectA.title still stay as is.
        // When changing a property of a struct, we actually change the Struct/recreate a new struct for
        // objectB, that's why we have to make it "var" for objectB so we can recreate the whole ojbectB
        objectB.title = "Second title"
    }
    
    private func classTest1() {
        let objectA = MyClass(title: "Starting Text")
        
        // Creating objectB is like creating a new MyStruct struct
        // and pass data from objectA to it.
        let objectB = objectA
        print("Object A", objectA.title)
        print("Object B", objectB.title)
        
        // When changing a property of a class, we just go in that instance and change its property
        // we don't have to mark the propery "var" like in struct.
        objectB.title = "Second title"
    }
}

//MARK: - Most about struct
struct MyStruct {
    var title: String
}

// Immutable struct
// make the property "let"
struct CustomStruct {
    let title: String
    
    func updateTitle(newTitle: String) -> CustomStruct {
        CustomStruct(title: newTitle)
    }
}

struct MutatingStruct {
    // When making a property private
    // we have to have init()
    //
    // Sometimes we want to do it this way so that we can restrict how
    // to change data of properties. We only want to change value by
    // func inside the struct instead of something like this
    // <instance>.title = something else.
    private(set) var title: String
    
    init(title: String) {
        self.title = title
    }
    
    /// The thing behind this is that it changes the struct/creates new struct with
    /// new value for "title", it doesn't just change value of title.
    mutating func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    private func structTest2() {
        print("structTest2")
        var struct1 = MyStruct(title: "title1")
        print("struct1: ", struct1.title)
        struct1.title = "Title2"
        print("struct1: ", struct1.title)
        
        var struct2 = CustomStruct(title: "title1")
        print("struct2: ", struct2.title)
        // One way to change data of an IMMUTABLE struct is to
        // create a new struct and pass to struct2
        struct2 = CustomStruct(title: "title2")
        print("struct2: ", struct2.title)
        
        // or we can create a func inside Struct
        // to create new Struct
        var struct3 = CustomStruct(title: "title1")
        print("struct3: ", struct3.title)
        struct3 = struct3.updateTitle(newTitle: "title2")
        print("struct3: ", struct3.title)
        
        var struct4 = MutatingStruct(title: "title1")
        print("struct4: ", struct4.title)
        struct4.updateTitle(newTitle: "title2")
        print("struct4: ", struct4.title)
    }
}

//MARK: - Most about class
class MyClass {
    var title: String
    
    init(title: String) {
        self.title = title
    }
    
    func updateTitle(newTitle: String) {
        title = newTitle
    }
}

extension StructClassActorBootcamp {
    private func classTest2() {
        print("classTest2")
        
        let class1 = MyClass(title: "title1")
        print("class1", class1.title)
        // Unlike Struct, when we change value of a property, we don't change the Struct
        // we just go in there and change the property's value, that's why we can
        // mark it "let" class1
        class1.title = "title2"
        print("class1", class1.title)
        
        let class2 = MyClass(title: "title1")
        print("class2", class2.title)
        class2.updateTitle(newTitle: "title2")
        print("class2", class2.title)
    }
}
