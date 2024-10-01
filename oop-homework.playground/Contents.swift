/* Date: Sep 25th
   Author: Randy Chang
   email: randy.w.chang@gmail.com
   Description: K
*/
import Swift

// Exercise 1
// 1.1 Define a class Post with properties of 'author', 'content' and 'likes'
class Post {
    let author: String
    let content: String
    var likes: Int
    
    init(author: String, content: String, likes: Int = 0) {
        self.author = author
        self.content = content
        self.likes = likes
    }
    
    // 1.2 Implment a method display() to prints a formatted string for the post
    func display() {
        print("\(author) wrote: \(content) with \(likes) likes")
    }
}

// 1.3 create two Post objects with different content and authors and call the display() method on each post object
func postTestMain() {
    
    var newPost: Post = Post(author: "Randy Chang", content: "'Hello, I'm struggling with Swift.'", likes: 10)
    var newPost2: Post = Post(author: "Elon Musk", content: "'FSD will run the world of mobility by 2030'", likes: 9999)

    newPost.display()
    newPost2.display()
}

postTestMain()



// Exercise 2

// 2.1 Create a class Product
class Product {
    
    let name: String
    let price: Double
    let quantity: Int
    
    init(name: String, price: Double, quantity: Int) {
        self.name = name
        self.price = price
        self.quantity = quantity
    }
}

// Define the DiscountStrategy protocol
protocol DiscountStrategy {
    func calculateDiscount(total: Double) -> Double
}

// Implement concrete discount strategy
class NoDiscountStrategy: DiscountStrategy {
    func calculateDiscount(total: Double) -> Double {
        return 0.0
    }
}

class PercentageDiscountStrategy: DiscountStrategy {
    
    let discountPercentage: Double
    
    init(discountPercentage: Double) {
        self.discountPercentage = discountPercentage
    }
    
    func calculateDiscount(total: Double) -> Double {
        return total * discountPercentage / 100
    }
}

// 2.2 Implement the ShoppingCart class Singleton design pattern
class ShoppingCartSingleton {
    
    //2.2.1
    private static let sharedInstance = ShoppingCartSingleton()

    private var products: [Product] = []
    
    // declare discountStragteby and initialize with no discount
    var discountStrategy: DiscountStrategy = NoDiscountStrategy()
    
    private init() {
        self.products = []
    }
    
    // Implment addProduct() mehtod
    public func addProduct(product: Product, qaunatity: Int) {
        let newProduct = Product(name: product.name, price: product.price, quantity: qaunatity)
        products.append(newProduct)
    }
    
    // Implement removeProduct() method
    public func removeProduct(product: Product) {
        if let index = products.firstIndex(where: { $0 === product }) {
            products.remove(at: index)
        }
    }
    
    // Implement clearCart() method
    public func clearCart() {
        products.removeAll()
    }
    
    // Implemnt getTotalPrice() method
    public func getTotalPrice() -> Double {
        var totalPrice: Double = 0.0
        for product in products {
            totalPrice += product.price * Double(product.quantity)
        }
        // Appy discount strategy
        return discountStrategy.calculateDiscount(total: totalPrice)
    }
}

// Exercise 3

// 3.1 Define a custom error type PaymentError
enum PaymentError: Error {
    case nsfAmount(errMsg: String)
    case invalidAmount(errMsg: String)
    case invalidCardNumber(errMsg: String)
}

// 3.1 Create a PaymenentProcessor Protocol w/ a method of processPayment which throws a custom error type PaymentError
protocol PaymentProcessor {
    func processPayment(amount: Double) throws
}

// 3.2 Create a concrete class CreditCardProcessor conforms to the PaymentProcessor Protocol.
class CreditCardProcessor: PaymentProcessor {
  
    var creditCardNumber: String
    
    // initialize with credit card number
    init(creditCardNumber: String)  {
        self.creditCardNumber = creditCardNumber
    }
    
    // implement protocol method
    func processPayment(amount: Double) throws {
        try processPayment(amount: amount, cardNumber: creditCardNumber)
    }
    
    private func processPayment(amount: Double, cardNumber: String) throws{
        if cardNumber.isEmpty || cardNumber.count < 16 {
            throw PaymentError.invalidCardNumber(errMsg: "Credit card number is not valid")
        }
        else if amount > 5000 {
            throw PaymentError.invalidAmount(errMsg: "Credit card amount has exceeded the limit")
        } else {
            
            print("Your credit card payment of $\(amount) for card number \(cardNumber) has been successfully processed.")
        }
        
    }
}


// 3.2 Create a concrete class CashProcessor conforms to the PaymentProcessor Protocol.
class CashProcessor: PaymentProcessor {
    func processPayment(amount: Double) throws {
        if amount > 5000 {
            throw PaymentError.nsfAmount(errMsg: "Non sufficient fund in your account for this payment.")
        } else {
            print("Your cash payment of $\(amount) has been sucessfully processed.")
        }
    }
}


// 3.3 Create a Main function to try different payment processor with try-catch blocks
func paymentProcessorTestMain() {
    let aCreditCardProcessor  = CreditCardProcessor(creditCardNumber: "1234567890000000")
    let anotherCreditCardProcessor = CreditCardProcessor(creditCardNumber: "1234")
    let aCashProcessor = CashProcessor()
    
    // Try different test cases with diffferent error messages
    // Maybe needs to refactor the following code to reduce the repetition
    do {
    try aCashProcessor.processPayment(amount: 4000)
    } catch PaymentError.nsfAmount(let msg) {
        print("Transaction failed: \(msg)" )
    } catch {
        print("some unknown errors")
    }
    
    do {
    try aCashProcessor.processPayment(amount: 10000)
    } catch PaymentError.nsfAmount(let msg) {
        print("Transaction failed: \(msg)" )
    } catch {
        print("some unknown errors")
    }
    
    do {
        try aCreditCardProcessor.processPayment(amount: 4000)
    } catch PaymentError.invalidCardNumber(let msg) {
        print("Transaction failed: \(msg)" )
    } catch PaymentError.invalidAmount(let msg){
        print("Transaction failed: \(msg)")
    } catch {
        print("some unknown errors")
    }
    
    do {
        try aCreditCardProcessor.processPayment(amount: 7000)
    } catch PaymentError.invalidCardNumber(let msg) {
        print("Transaction failed: \(msg)" )
    } catch PaymentError.invalidAmount(let msg){
        print("Transaction failed: \(msg)")
    } catch {
        print("some unknown errors")
    }
    
    do {
        try anotherCreditCardProcessor.processPayment(amount: 7000)
    } catch PaymentError.invalidCardNumber(let msg) {
        print("Transaction failed: \(msg)" )
    } catch PaymentError.invalidAmount(let msg){
        print("Transaction failed: \(msg)")
    } catch {
        print("something else")
    }
    
}


// Test run for Exercise 3 code
paymentProcessorTestMain()

