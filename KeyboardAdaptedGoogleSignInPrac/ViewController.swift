//
//  ViewController.swift
//  KeyboardAdaptedGoogleSignInPrac
//
//  Created by Chun-Li Cheng on 2022/12/6.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var fbLoginBtn: UIButton!
    @IBOutlet weak var googleLoginBtn: UIButton!
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    // 正在使用的編輯框
    private var activeTextField: UITextField!
    // 主 view 因鍵盤擋住，要移動的高度
    private let offsetY: CGFloat = 20
    
    override func viewDidLoad() {
        super.viewDidLoad()
        keyboardShouldReturn()
        setKeyboardNotification()
    }
    
    // 鍵盤擋住提高 view
    @objc private func keyboardShown(notification: Notification) {
        let info: NSDictionary = notification.userInfo! as NSDictionary
        // 取得鍵盤尺寸、位置
        let keyboardSize = (info[UIResponder.keyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
        
        // 鍵盤頂部 Y 的位置
        let keyboardY = self.view.frame.height - keyboardSize.height
        // 編輯框底部 Y 的位置
        let textFieldY = activeTextField.convert(activeTextField.bounds,
                                                 to: self.view).maxY
        // 相減得知編輯框被鍵盤擋住多少（ > 0 有擋住 ； < 0 沒擋住 ）
        let targetY = textFieldY - keyboardY

        // 在 view 沒有提高，編輯框也被鍵盤擋住時
        if !(self.view.frame.minY < 0),
           targetY > 0 {
            
            UIView.animate(withDuration: 0.25,
                           animations: {
                // view 提高 targetY + offsetY
                self.view.frame = CGRect(x: 0,
                                         y:  -targetY - self.offsetY,
                                         width: self.view.bounds.width,
                                         height: self.view.bounds.height)
            })
        }

    }

    // 收鍵盤 view 回原位
    @objc private func keyboardHidden(notification: Notification) {
        UIView.animate(withDuration: 0.25,
                       animations: {
            
            self.view.frame = CGRect(x: 0,
                                     y: 0,
                                     width: self.view.bounds.width,
                                     height: self.view.bounds.height)
        })
    }
    
    private func setKeyboardNotification() {
        // 監聽鍵盤顯示、隱藏
        let center: NotificationCenter = NotificationCenter.default
        center.addObserver(self,
                           selector: #selector(keyboardShown),
                           name: UIResponder.keyboardWillShowNotification,
                           object: nil)
        center.addObserver(self,
                           selector: #selector(keyboardHidden),
                           name: UIResponder.keyboardWillHideNotification,
                           object: nil)
    }

    
    private func keyboardShouldReturn() {
        userNameTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        userNameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }
    

}

extension ViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        // 正在使用的編輯框
        activeTextField = textField
    }
}

