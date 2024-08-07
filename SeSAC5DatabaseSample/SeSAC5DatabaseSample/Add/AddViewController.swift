//
//  AddViewController.swift
//  SeSAC5DatabaseSample
//
//  Created by jack on 7/2/24.
//

import UIKit

import PhotosUI
import SnapKit
//import RealmSwift // <- var repository = TodoTableRepository() 때문에 제외해도 댐!

import Toast

protocol PassCategoryDataDelegate {
    func passCategoryValue(_ text: String)
}
class AddViewController: BaseViewController {
    
    var repository = TodoTableRepository()
    
    var folder: Folder?
    
    let moneyButton = UIButton()
    let categoryButton = UIButton()
    let memoButton = UIButton()
    let photoImageView = UIImageView()
    let addButton = UIButton()
    let titleTextField = UITextField()
    let contentTextField = UITextField()
    
    var showToast: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let folder = folder {
            navigationItem.title = "\(folder.name) 목록 추가"
        }
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(memoReceivedNotification),
            name: NSNotification.Name("memoReceived"), 
            object: nil
        )
        
    }
    
    @objc func memoReceivedNotification(notification: NSNotification) {
        
        if let info = notification.userInfo?["content"] as? String {
            memoButton.setTitle(info, for: .normal)
        }
    }
    
    override func configureHierarchy() {
        view.addSubview(moneyButton)
        view.addSubview(categoryButton)
        view.addSubview(memoButton)
        view.addSubview(photoImageView)
        view.addSubview(addButton)
        view.addSubview(titleTextField)
        view.addSubview(contentTextField)
    }
    
    @objc func saveButtonClicked() {
        print(#function)
        // 1. 텍스트필드에 작성한 텍스트가 저장되도록 수정
        // 2. 제목이 비어있다면(isEmpty) 저장되지않고 얼럿 띄우기
        // 3. 저장 완료 이후에는 메인 화면으로 전환
        view.makeToast("저장되었음")
        // Create 1️⃣ Realm 위치 찾기
        //let realm = try! Realm() // 데이터가 있는 위치를 찾아가는 코드
        
        guard let title = titleTextField.text, !title.isEmpty,
              let content = contentTextField.text
        else {
            // 1.
            let alert = UIAlertController(
                title: "제목이 비어있습니다!!",
                message: "제목은 옵셔널이 아니라서 입력해야합니다ㅡㅡ",
                preferredStyle: .alert)
            
            // 2.
            let confirm = UIAlertAction(
                title: "확인",
                style: .default)
            
            // 3.
            alert.addAction(confirm)
            
            // 4.
            present(alert, animated: true)
            return
        }
        
        let data = TodoTable(momoTitle: title, memoContent: content, money: Int.random(in: 1...100) * 1000, category: "식비", resisterDate: Date())
        //        try! realm.write {
        //            realm.add(data)
        //            print("Realm Create Succeed")
        //        }
        // ⬇️ 이렇게 한줄로!
        repository.createItem(data, folder: folder!)
        
        if let image = photoImageView.image {
            saveImageToDocument(image: image, filename: "\(data.id)")
        }
        showToast?()
        
        navigationController?.popViewController(animated: true)
    }
    
    override func configureView() {
        super.configureView()
        
        addButton.backgroundColor = .black
        addButton.setTitleColor(.white, for: .normal)
        addButton.setTitle("이미지 추가", for: .normal)
        addButton.addTarget(self, action: #selector(addButtonClicked), for: .touchUpInside)
        
        photoImageView.backgroundColor = .lightGray
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(saveButtonClicked))
        
        moneyButton.backgroundColor = .black
        moneyButton.setTitleColor(.white, for: .normal)
        moneyButton.setTitle("금액", for: .normal)
        moneyButton.addTarget(self, action: #selector(moneyButtonClicked), for: .touchUpInside)
        
        categoryButton.backgroundColor = .black
        categoryButton.setTitleColor(.white, for: .normal)
        categoryButton.setTitle("카테고리", for: .normal)
        categoryButton.addTarget(self, action: #selector(categoryButtonClicked), for: .touchUpInside)
        
        memoButton.backgroundColor = .black
        memoButton.setTitleColor(.white, for: .normal)
        memoButton.setTitle("메모", for: .normal)
        memoButton.addTarget(self, action: #selector(memoButtonClicked), for: .touchUpInside)
        
        titleTextField.placeholder = "제목을 입력해보세요"
        contentTextField.placeholder = "내용을 입력해보세요"
    }
    
    override func configureConstraints() {
        
        moneyButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(20)
        }
        
        categoryButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(moneyButton.snp.bottom).offset(20)
        }
        
        memoButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(categoryButton.snp.bottom).offset(20)
        }
        
        photoImageView.snp.makeConstraints { make in
            make.size.equalTo(200)
            make.centerX.equalTo(view)
            make.top.equalTo(memoButton.snp.bottom).offset(20)
        }
        
        addButton.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(photoImageView.snp.bottom).offset(20)
        }
        
        titleTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(addButton.snp.bottom).offset(20)
        }
        
        contentTextField.snp.makeConstraints { make in
            make.width.equalTo(300)
            make.height.equalTo(48)
            make.centerX.equalTo(view)
            make.top.equalTo(titleTextField.snp.bottom).offset(20)
        }
    }
    // UIColorPickerViewController
    // PHPickerViewController: Out of process
    // ✅UIImagePickerController: 촬영/ 갤러리
    // ➡️단순히 갤러리를 보여주고 가져오는 부분은 권한 필요 ❌
    // ➡️➡️➡️언제 찍었냐 어디서 찍었냐 렌즈가 뭐냐 -> 권한 필요 🅾️
    // ➡️➡️➡️이미지를 갤러리에 저장하고 싶을 때도 권한 필요 🅾️
    
    @objc func addButtonClicked() {
        print(#function)
        // - 사진
        //        let picker = UIImagePickerController()
        //        picker.delegate = self
        //        picker.allowsEditing = true
        //        picker.sourceType = .camera //🧡
        //        present(picker, animated: true)
        
        var configuration = PHPickerConfiguration()
        configuration.selectionLimit = 3
        configuration.filter = .any(of: [.images, .depthEffectPhotos]) // 비디오.. 등
        
        let picker = PHPickerViewController(configuration: configuration)
        picker.delegate = self
        
        present(picker, animated: true)
    }
    
    @objc func memoButtonClicked() {
        
        let vc = MemoViewController()
        // 이때 다음 페이지로 값을 전달하고 싶다.
        NotificationCenter.default.post(
            name: NSNotification.Name("SendMemo"),
            object: nil,
            userInfo: ["memo": memoButton.currentTitle ?? ""]
        )
        
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func moneyButtonClicked() {
        
        let vc = MoneyViewController()
        vc.nickname = { [weak self] money in
            print("으아아아아", money)
            self?.moneyButton.setTitle(money, for: .normal)
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func categoryButtonClicked() {
        
        let vc = CategoryViewController()
        vc.sendCategory = self // 👈 현재 쓰고 있는 인스턴스
        //        vc.sendCategory = { [weak self] category in
        //            self?.categoryButton.setTitle(category, for: .normal)
        //        }
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension AddViewController: PassCategoryDataDelegate {
    func passCategoryValue(_ text: String) {
        print(#function, text)
        categoryButton.setTitle(text, for: .normal)
    }
}

extension AddViewController: UIFontPickerViewControllerDelegate, UIColorPickerViewControllerDelegate {
    
}

// 이 두가지는 따라 다닌다고 기억✅
extension AddViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // ⬇️
        //info[UIImagePickerController.InfoKey.originalImage] as ? UIImage
        if let image = info[.originalImage] as? UIImage {
            photoImageView.image = image
        }
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print(#function)
        dismiss(animated: true)
    }
    
}

extension AddViewController: PHPickerViewControllerDelegate {
    
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        dismiss(animated: true)
        print("1",Thread.isMainThread)
        if let itemProvider = results.first?.itemProvider,
           itemProvider.canLoadObject(ofClass: UIImage.self) {
            itemProvider.loadObject(ofClass: UIImage.self) {
                image, error in
                print("2",Thread.isMainThread)
                DispatchQueue.main.async {
                    self.photoImageView.image = image as? UIImage //➡️ 글로벌 스레드로 보냈기 때문에..
                }
            }
        }
    }
}
