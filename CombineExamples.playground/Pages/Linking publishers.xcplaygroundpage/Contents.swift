//: [Previous](@previous)

import Combine

/// In order to pass data between publishers we use the flatMap operator. You can think of it as taking the output of one publisher and using it as input to another to create a chain-like dataflow
/// E.g.

let intPublisher: PassthroughSubject<Int, Never> = .init()


intPublisher
    .flatMap { CurrentValueSubject<String, Never>("\($0)") }
    .flatMap { CurrentValueSubject<Double, Never>(Double($0)!) }
    .sink { double in
        print("output is double: \(double)")
}

intPublisher.send(1)



//: [Next](@next)
