import UIKit
import Combine

/// In Combine there are `Publishers`  and `Subscribers`. Publishers emit data over time. Let's make a type of Publisher:

let publisher: PassthroughSubject<String, Never> = .init()
    
/// Lifting real world data like textinput into the world of publishers is in Combine done using Subjects. There are `CurrentValueSubjects` that hold on to their value and thus always has one to give, and `PassthroughSubjects` like the one above that only pass on values when they receive one.
/// As a Subscriber you need to subscribe to a Publisher in order to receive data. The simplest Subcriber is called `Sink`and is provided by Combine. It looks like this when you use it:

publisher.sink { text in
    print(text)
}
/// As you can see,`Sink`is a Subscriber that transforms the data from the Publisher world back into the world of closures.
///
/// To get a Subject to publish data you invoke the `.send(_:)` method, like so:
///
publisher.send("Hello, old friend")
///
/// So in order to publish some characters entered and print them by subscribing, this is how you could do it:

let textObserver: PassthroughSubject<String, Never> = .init()


var textCancellable = textObserver
    .sink { text in
        print(text)
}
textObserver.send("H")
textObserver.send("e")
textObserver.send("l")
textObserver.send("l")
textObserver.send("o")

/// cancel our current subscription
textCancellable.cancel()

/// When you subscribe to a publisher you get a token back, a `Cancellable`. The subscription lives until the Cancellable is deallocated or `.cancel()` is called on it, which means you need to store the cancellable somewhere to get any output. If the cancellable is deallocated, your subscription is terminated


func subscribeTo(_ stream: PassthroughSubject<String, Never>) {
    // since this `localCancellable` is in this functions scope the subscrition is cancelled directly after the function extits
    let localCancellable = stream.sink { text in
            print(text)
    }
}

subscribeTo(textObserver)

textObserver.send("n")
textObserver.send("e")
textObserver.send("v")
textObserver.send("e")
textObserver.send("r")

/// this code block results in no prints since subscribeTo deallocated the subscription on  exit of the scope

func subscribeToWithCancellable(_ stream: PassthroughSubject<String, Never>) -> AnyCancellable {
    // since this `localCancellable` is returned code out side this scope can store and maintain the subscription
    let localCancellable = stream.sink { text in
            print(text)
    }
    return localCancellable
}

/// here we store the Cancellable, and the subscription is maintained
textCancellable = subscribeToWithCancellable(textObserver)

textObserver.send("Cancellable")
textObserver.send("Persisted")
