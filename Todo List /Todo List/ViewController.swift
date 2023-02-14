import UIKit
import RealmSwift
class ViewController: UIViewController {
     
    let realm = try? Realm()
    
        var realmArray: [ToDoListBase] = []
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var model : ToDoListBase?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.white
        self.navigationItem.title = "Tasks List"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        
        
        tableView.dataSource = self
        tableView.delegate = self
    }
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
        self.realmArray = []
        guard let infoMatchesResult = realm?.objects(ToDoListBase.self) else {return}
        for match in infoMatchesResult{
            self.realmArray.append(match)
        }
        self.tableView.reloadData()
        }
    
     func deleteTask(indexPath: IndexPath) {
         let task = realmArray[indexPath.row]
         do {
             let realm = try Realm()
             try realm.write {
                 realm.delete(task)
             }
             realmArray.remove(at: indexPath.row)
             tableView.deleteRows(at: [indexPath], with: .fade)
         } catch {
         }
     }

    
    // MARK: Create edit button
    @IBAction func pushEditAction(_ sender: Any) {
        tableView.setEditing(!tableView.isEditing, animated: true)
    }
    
   
    @IBAction func addAletr(_ sender: Any) {
        showAllert()
    }
    
    
    // MARK: - Create alert save
    func showAllert() {
        
         let infoBaseRealm = ToDoListBase()
         
             let alert = UIAlertController(title: "Поставьте задачу", message: "Заполните поля для задачи", preferredStyle: .alert)
             alert.addTextField { (textField) in
                 textField.placeholder = "Название задачи"
             }
             alert.addTextField { (textField) in
                 textField.placeholder = "Краткое описание"
             }
             alert.addTextField { (textField) in
                 textField.placeholder = "Дата когда нужно выполнить"
             }
        let action = UIAlertAction(title: "Сохранить", style: .default) { save in
             
             let format = DateFormatter()
             format.dateFormat = "dd.MM.YYYY"
             format.timeZone = TimeZone(abbreviation: "GMT+0:00")
             
             var model:ToDoListBase?
             let textFields = alert.textFields
             
             guard let title = textFields?[0].text,
                   let description = textFields?[1].text,
                   let dateDo = textFields?[2].text else { return }
             
             let dateD = format.date(from:dateDo)
             
             let infoBaseRealm = ToDoListBase()
             infoBaseRealm.nameOfToDo = title
             infoBaseRealm.shortDescription = description
             infoBaseRealm.finishTime = dateD!
             do {
                 let realm = try Realm()
                 try realm.write {
                     realm.add(infoBaseRealm)
                 }
                 self.realmArray = []
                 guard let infoMatchesResult = self.realm?.objects(ToDoListBase.self)
                 else {return}
                 for match  in infoMatchesResult{
                     self.realmArray.append(match)
                 }
                 self.tableView.reloadData()
             }catch{
             }
         }
         alert.addAction(action)
         self.present(alert, animated: true, completion: nil)
         
    }
                                                      
    
   
    private func showSuccessfulSave(title:String) {
        let alert = UIAlertController(title:"\(title)" , message: "Успешно выполнено.", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "ок", style: .default))
        self.present(alert,animated: true, completion: nil)
    }
    // MARK: - Create alert delete
    private func showSuccessfulDelete(title:String) {
        let alert = UIAlertController(title:"\(title)" , message: " Задача удалена. ", preferredStyle:.alert)
        alert.addAction(UIAlertAction(title: "ок", style: .default))
        self.present(alert,animated: true, completion: nil)
    }

}
//MARK: Table view data sourse

extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
//        let from = realmArray[sourceIndexPath.row]
//        realmArray.remove(at:sourceIndexPath.row)
//        realmArray.insert(<#T##newElement: ToDoListBase##ToDoListBase#>, at: <#T##Int#>)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return realmArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM//yyyy hh:mm:ss"
        let timeString = dateFormatter.string(from: realmArray[indexPath.row].addingTime)
        cell.detailTextLabel?.text = timeString
        cell.textLabel?.text  = realmArray[indexPath.row].nameOfToDo ?? ""
               return cell
    }
}
//MARK: Table view delegate

extension ViewController: UITableViewDelegate {
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let main = UIStoryboard(name: "Main", bundle: nil)
        let data = realmArray[indexPath.row]
        if let vc = main.instantiateViewController(withIdentifier: "DetailViewController") as? DetailViewController {
            vc.model = data
            navigationController?.pushViewController(vc, animated: true)
            tableView.deselectRow(at: indexPath, animated: true)
                       
        }
    }
        
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let action3 = UIContextualAction(style: .normal, title:"Удалить") { _, _, completion in
            completion(true)
            let alert = UIAlertController(title: "Вы уверены что хотите удалить задачу?", message: nil, preferredStyle: .alert)
                        let action = UIAlertAction(title: "Да", style: .default) { (action) in
                            let task = self.realmArray[indexPath.row]
                            do {
                                let realm = try Realm()
                                try realm.write {
                                    realm.delete(task)
                                }
                                self.realmArray.remove(at: indexPath.row)
                                self.tableView.deleteRows(at: [indexPath], with: .fade)
                            } catch {
                            }
                        }
                        alert.addAction(action)
                        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel))
            self.present(alert, animated: true, completion: nil)
        }
        
        action3.backgroundColor = .red
        
        return UISwipeActionsConfiguration(actions:[action3])
    }
          

    
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let action1 = UIContextualAction(style: .normal, title:"Выполнено") { _, _, completion in
            completion(true)
            self.showSuccessfulSave(title: Array().listArray[indexPath.row])
        }
        let action2 = UIContextualAction(style: .normal, title:"Редактировать") { _, _, completion in
            completion(true)
        }
            action1.backgroundColor = .green
            action2.backgroundColor = .orange
         
            return UISwipeActionsConfiguration(actions: [action1, action2])
        }
    }

    

