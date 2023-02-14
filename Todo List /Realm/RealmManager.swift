import Foundation
import RealmSwift

struct RealmManager {
    
    // MARK: - delet from realm
    
    func realmDelete(idObjToDel: String) {
        do {
            let realm = try Realm()
            let object = realm.objects(ToDoListBase.self).filter("title = %@", idObjToDel).first
            try! realm.write {
                if let obj = object {
                    realm.delete(obj)
                }
            }
        } catch let error as NSError {
           print(error)
            
        }
    }
}
