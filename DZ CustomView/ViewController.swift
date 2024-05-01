import UIKit
import SnapKit
import RealmSwift

class ViewController: UIViewController, IconLabelViewDelegate {
  
    let realm = try! Realm()
    
    var cars = [Car]() {
        didSet {
            tableView.reloadData()
        }
    }
    
    lazy var type: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .bezel
        textfield.placeholder = "Enter a type car"
        return textfield
    }()
    lazy var model: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .bezel
        textfield.placeholder = "Enter a model car"
        return textfield
    }()
    lazy var hpower: UITextField = {
        let textfield = UITextField()
        textfield.borderStyle = .bezel
        textfield.placeholder = "Enter a horse power"
        return textfield
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("tap me", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .gray
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        button.addTarget(self, action: #selector(setName), for: .touchDragInside)
        return button
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        return tableView
    }()
    
    lazy var iconWithText: IconLabelView = {
        let view = IconLabelView()
        view.configure(iconName: "person.fill", title: "I’ll pick it up myself")
        view.delegate = self
        return view
    }()
    
    
    lazy var iconWithText2: IconLabelView2 = {
        let view = IconLabelView2()
        view.configure(iconName: "person.fill", title: "I’ll pick it up myself")
        view.action = { [weak self] in
            print("button tapped")
        }
        return view
    }()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
        getCars()
    }
    
    private func setupViews() {
        view.addSubview(type)
        view.addSubview(model)
        view.addSubview(hpower)
        view.addSubview(button)
        view.addSubview(iconWithText)
        view.addSubview(iconWithText2)

        
        view.backgroundColor = .white
        
        type.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        model.snp.makeConstraints { make in
            make.top.equalTo(type.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }
        hpower.snp.makeConstraints { make in
            make.top.equalTo(model.snp.bottom).offset(10)
            make.leading.trailing.equalToSuperview().inset(16)
            make.height.equalTo(50)
        }

        button.snp.makeConstraints { make in
            make.width.equalTo(100)
            make.centerX.equalToSuperview()
            make.top.equalTo(hpower.snp.bottom).offset(12)
            make.height.equalTo(40)
        }
        
        iconWithText.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(button.snp.bottom).offset(12)
        }
        iconWithText2.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(12)
            make.top.equalTo(iconWithText.snp.bottom).offset(12)

        }
    }
    
    @objc func buttonTapped() {
        let car = Car()
        car.type = type.text ?? ""
        car.model = model.text ?? ""
        car.hpower = hpower.text ?? ""

        type.text = ""
        model.text = ""
        hpower.text = ""

        try! realm.write {
            realm.add(car)
        }
        getCars()
    }
    
    @objc func setName() {
        getCars()
    }
    
    func iconButtonTapped() {
        print("tapped")
    }
    
    private func getCars() {
        let cars = realm.objects(Car.self)
        
        self.cars = cars.map({ car in
            car
        })
    }
    
    private func deleteCar(_ car: Car) {
        try! realm.write {
            realm.delete(car)
        }
    }
    
    private func updateCartype(to type: String?, to model: String?, to hpower: String?, at index: Int) {
        
        let car = realm.objects(Car.self)[index]
        
        try! realm.write ({
            if let type = type, !type.isEmpty {
                car.type = type
            }
            if let model = model, !model.isEmpty {
                car.model = model
            }
            if let hpower = hpower, !hpower.isEmpty {
                car.hpower = hpower
            }
        })

    }
    
}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cars.count
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let car = cars[indexPath.row]
            cell.textLabel?.text = "\(car.type) \(car.model) \(car.hpower)"

        return cell
    }
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let editAction = UIContextualAction(style: .normal, title: "Edit") { [weak self] (_, _, completionHandler) in
            self?.editCar(at: indexPath)
            completionHandler(true)
        }
        editAction.backgroundColor = .blue
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.deleteCar(at: indexPath)
            completionHandler(true)
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    

    private func editCar(at indexPath: IndexPath) {
        updateCartype(to: type.text ?? "", to: model.text ?? "", to: hpower.text ?? "", at: indexPath.row)

        type.text = ""
        model.text = ""
        hpower.text = ""
        getCars()

    }
    
    private func deleteCar(at indexPath: IndexPath) {
        let car = cars[indexPath.row]
        deleteCar(car)
        getCars()
        
    }
}

