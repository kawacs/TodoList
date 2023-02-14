import Foundation
import RealmSwift

class ToDoListBase: Object{
    @Persisted(primaryKey: true) var nameOfToDo :String?
    @Persisted var shortDescription: String
    @Persisted var addingTime: Date = Date()
    @Persisted var finishTime: Date = Date()
}
