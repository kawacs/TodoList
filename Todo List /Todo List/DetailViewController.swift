import UIKit

class DetailViewController: UIViewController {
    
    @IBOutlet weak var nameTask: UILabel!
    @IBOutlet weak var stopDate: UILabel!
    @IBOutlet weak var createDate: UILabel!
    @IBOutlet weak var overviewTastk: UILabel!
    
    var model: ToDoListBase?
    override func viewDidLoad() {
        super.viewDidLoad()
        let format = DateFormatter()
        format.dateFormat = "dd.MM.YYYY"
        format.timeZone = TimeZone(abbreviation: "GMT+0:00")
        
        guard let model else {return}
        
        nameTask.text = model.nameOfToDo
        overviewTastk.text = model.shortDescription
        createDate.text = format.string(from: model.addingTime)
        stopDate.text = format.string(from: model.finishTime)
        
    }
    
    //Todo edit Task logic
    @IBAction func editTask(_ sender: Any) {
      
            
        }
    }

