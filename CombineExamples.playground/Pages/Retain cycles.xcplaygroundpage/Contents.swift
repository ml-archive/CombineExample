//: [Previous](@previous)

import Foundation
import PlaygroundSupport
import Combine
import UIKit

/// Since saving a Cancellable on an instance that may have reference to self, it's important to avoid retain cycles
/// If you are referencing self in a publisher chain where self is holding on to the subscription via a cancellable, you can capture unowned self, like so

class SomeVC: UIViewController {
    
    var cancellables: Set<AnyCancellable> = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        doSomethingAsynchronous()
            .flatMap { [unowned self] _ in self.doSomethingAsynchronous2() }
            .sink(receiveCompletion: { _ in
                print("Done")
            }, receiveValue: {_ in })
        .store(in: &cancellables)
        
    }
    
    func doSomethingAsynchronous() -> AnyPublisher<Void, Never> {
        Empty<Void, Never>(completeImmediately: true).eraseToAnyPublisher()
    }
    func doSomethingAsynchronous2() -> AnyPublisher<Void, Never> {
          Empty<Void, Never>(completeImmediately: true).eraseToAnyPublisher()
    }
}

let vc = SomeVC()
_ = vc.view

// Make sure to always use the reference cycle tool in XCode to avoid leaks

//: [Next](@next)
