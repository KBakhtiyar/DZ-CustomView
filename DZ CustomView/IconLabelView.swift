import UIKit

class IconLabelView: UIView {
    
    var delegate: IconLabelViewDelegate?
    
    lazy var iconImage: UIImageView = {
        let image = UIImageView()
        return image
    }()
    
    lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14, weight: .regular)
        label.textColor = .secondaryLabel
        return label
    }()

    lazy var button: UIButton = {
        let button = UIButton()
        button.setTitle("Tap me", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
        return button
    }()
    
    @objc func buttonTapped() {
    delegate?.iconButtonTapped()
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
        titleLabel.text = title
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

protocol IconLabelViewDelegate {
    func iconButtonTapped()
}
