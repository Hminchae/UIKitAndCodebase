//
//  ViewController.swift
//  Lotto
//
//  Created by 황민채 on 6/5/24.
//

import UIKit

import Alamofire
import SnapKit

class LookUpLottoViewController: UIViewController, UITextFieldDelegate {
    
    let lottoRoundTextField = UITextField()
    
    // 당첨번호 안내 label
    let infoLabel = {
        let label = UILabel()
        label.textColor = .label
        label.text = "당첨번호 안내"
        label.font = .systemFont(ofSize: 15)
        return label
    }()
    // ex) 2020-08-20 추첨
    let infoOfRoundLabel = UILabel()
    
    let separaterView = UIView()
    
    // 회차
    let roundStack = UIStackView()
    
    var keyRound: Int = 986
    let roundLabel = UILabel()
    let resultLabel = {
        let label = UILabel()
        label.text = "당첨결과"
        label.font = .boldSystemFont(ofSize: 20)
        label.textColor = .label
        
        return label
    }()
    
    let ballStack = UIStackView()
    
    var stackItem1 = UILabel()
    var stackItem2 = UILabel()
    var stackItem3 = UILabel()
    var stackItem4 = UILabel()
    var stackItem5 = UILabel()
    var stackItem6 = UILabel()
    var stackItem7 = UILabel()
    let stackItemPlus = UILabel()
    
    let pickerView = UIPickerView()
    
    let numbers = Array(1...986).reversed() as [Int]
    
    var lottoWidth: CGFloat = 0
    
    let bonusLabel = {
        let label = UILabel()
        label.text = "보너스"
        label.font = .systemFont(ofSize: 13)
        label.textColor = .darkGray
        
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierachy()
        
        lottoRoundTextField.inputView = pickerView
        
        pickerView.delegate = self
        pickerView.dataSource = self
        lottoRoundTextField.delegate = self

        configureLayout()
        configureUI()
        configureNetwork()
        configureRoundStack()
        configureBallStack()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(anyTapped))
        view.addGestureRecognizer(tapGesture)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        lottoWidth = ballWidth()
    }
    
    @objc func anyTapped() {
        lottoRoundTextField.endEditing(true)
    }
    
    func configureHierachy() {
        view.addSubview(lottoRoundTextField)
        view.addSubview(infoLabel)
        view.addSubview(infoOfRoundLabel)
        view.addSubview(separaterView)
        view.addSubview(roundStack)
        view.addSubview(ballStack)
        view.addSubview(bonusLabel)
        
    }

    
    func configureNetwork() {
        
        let url = "\(APIURL.lottoURL)\(keyRound)"
        
        AF.request(url).responseDecodable(of: Lotto.self) { response in
            switch response.result {
            case .success(let value):
                print(value.lottoDate)
                print(self.lottoWidth)
                self.infoOfRoundLabel.text = "\(value.lottoDate) 추첨"
                self.stackItem1.setBallUI(value.num1, width: self.lottoWidth)
                self.stackItem2.setBallUI(value.num2, width: self.lottoWidth)
                self.stackItem3.setBallUI(value.num3, width: self.lottoWidth)
                self.stackItem4.setBallUI(value.num4, width: self.lottoWidth)
                self.stackItem5.setBallUI(value.num5, width: self.lottoWidth)
                self.stackItem6.setBallUI(value.num6, width: self.lottoWidth)
                self.stackItem7.setBallUI(value.num7, width: self.lottoWidth)
                self.stackItemPlus.setPlusLabelUI()
            case .failure(let error):
                print(error)
            }
        }
    }
}

// configureUI
extension LookUpLottoViewController {
    func configureRoundStack() {
        roundStack.translatesAutoresizingMaskIntoConstraints = false
        roundStack.axis = .horizontal
        roundStack.spacing = 0
        roundStack.distribution = .fillEqually
        roundStack.isLayoutMarginsRelativeArrangement = false
        
        roundStack.addArrangedSubview(roundLabel)
        roundStack.addArrangedSubview(resultLabel)
    }
    
    func configureBallStack() {
        ballStack.translatesAutoresizingMaskIntoConstraints = false
        ballStack.axis = .horizontal
        ballStack.spacing = 10
        ballStack.distribution = .fillEqually
        ballStack.alignment = .fill
        ballStack.isLayoutMarginsRelativeArrangement = false // 레이아웃 마진 제거
        
        ballStack.addArrangedSubview(stackItem1)
        ballStack.addArrangedSubview(stackItem2)
        ballStack.addArrangedSubview(stackItem3)
        ballStack.addArrangedSubview(stackItem4)
        ballStack.addArrangedSubview(stackItem5)
        ballStack.addArrangedSubview(stackItem6)
        ballStack.addArrangedSubview(stackItemPlus)
        ballStack.addArrangedSubview(stackItem7)
    }
    
    func configureLayout() {
        lottoRoundTextField.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(45)
        }
        
        infoLabel.snp.makeConstraints { make in
            make.top.equalTo(lottoRoundTextField.snp_bottomMargin).offset(20)
            make.leading.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        infoOfRoundLabel.snp.makeConstraints { make in
            make.top.equalTo(lottoRoundTextField.snp_bottomMargin).offset(20)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
        
        separaterView.snp.makeConstraints { make in
            make.top.equalTo(infoOfRoundLabel.snp_bottomMargin).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(0.5)
        }
        
        roundStack.snp.makeConstraints { make in
            make.top.equalTo(separaterView.snp.bottom).offset(20)
            make.centerX.equalTo(view.center)
            make.width.equalTo(150)
            make.height.equalTo(30)
        }
        
        ballStack.snp.makeConstraints { make in
            make.top.equalTo(roundStack.snp.bottom).offset(20)
            make.horizontalEdges.equalTo(view.safeAreaLayoutGuide).inset(20)
            make.height.equalTo(34)
        }
        
        bonusLabel.snp.makeConstraints { make in
            make.top.equalTo(ballStack.snp.bottom).offset(10)
            make.trailing.equalTo(view.safeAreaLayoutGuide).inset(20)
        }
    }
    
    func configureUI() {
        lottoRoundTextField.borderStyle = .roundedRect
        lottoRoundTextField.layer.cornerRadius = 10
        lottoRoundTextField.tintColor = .gray
        lottoRoundTextField.textAlignment = .center
        
        infoOfRoundLabel.font = .systemFont(ofSize: 13)
        infoOfRoundLabel.textColor = .darkGray
        
        separaterView.backgroundColor = .lightGray
        
        roundLabel.text = "\(keyRound)회"
        roundLabel.font = .boldSystemFont(ofSize: 20)
        roundLabel.textColor = UIColor.random()
    }
    
    func ballWidth() -> CGFloat {
        let originWidth = view.window?.windowScene?.screen.bounds.width
        let result = ((originWidth ?? 393) - 110) / 8
        
        return result
    }
}
extension LookUpLottoViewController : UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        numbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        keyRound = numbers[row]
        roundLabel.text = "\(numbers[row])회"
        lottoRoundTextField.text = "\(numbers[row])회차"
        configureNetwork()
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return "\(numbers[row])회차"
    }
}
