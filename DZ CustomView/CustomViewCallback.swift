import UIKit

class IconLabelView2: UIView {
        
    var action: (() -> ())?
    
    lazy var iconImage: UIImageView = {
       let image = UIImageView()
        return image
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Tap me", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonTapped() {
        action?()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(iconName: String, title: String) {
        iconImage.image = UIImage(systemName: iconName)
    }
    
    private func setupViews() {
        self.addSubview(iconImage)
        self.addSubview(button)

        setupConstraints()
    }
    
    private func setupConstraints() {
        iconImage.snp.makeConstraints { make in
            make.leading.centerY.equalToSuperview()
            make.width.height.equalTo(24)
        }
        
        button.snp.makeConstraints { make in
            make.top.bottom.trailing.equalToSuperview()
            make.leading.equalTo(iconImage.snp.trailing).offset(16)
        }
        
    }
}
