import Foundation
import RealmSwift

class Car: Object{
    @Persisted var type: String
    @Persisted var model: String
    @Persisted var hpower: String
    
}
