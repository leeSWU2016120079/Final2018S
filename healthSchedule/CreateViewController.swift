//
//  CreateViewController.swift
//  healthView_test
//
//  Created by SWUCOMPUTER on 2018. 5. 22..
//  Copyright © 2018년 SWUCOMPUTER. All rights reserved.
//

import UIKit

class CreateViewController: UIViewController, UITextFieldDelegate {
    
    @IBOutlet var textID: UITextField!
    @IBOutlet var textPassword: UITextField!
    @IBOutlet var textName: UITextField!

    func textFieldShouldReturn (_ textField: UITextField) -> Bool {
        if textField == self.textID { textField.resignFirstResponder()
            self.textPassword.becomeFirstResponder()
        }
        else if textField == self.textPassword {
            textField.resignFirstResponder()
            self.textName.becomeFirstResponder()
        }
        textField.resignFirstResponder()
        return true
    }
    func executeRequest (request: URLRequest) -> Void {
        let session = URLSession.shared
        let task = session.dataTask(with: request) { (responseData, response, responseError) in
            guard responseError == nil else { print("Error: calling POST")
                return }
            guard let receivedData = responseData else { print("Error: not receiving Data")
                return }
            if let utf8Data = String(data: receivedData, encoding: .utf8) {
                DispatchQueue.main.async { // for Main Thread Checker
                    self.showToast(message: utf8Data)
                    print(utf8Data) // php에서 출력한 echo data가 debug 창에 표시됨
                    
                }
            }
            
        }
        task.resume()
    }
    
    
    @IBAction func buttonCreate() {
        
        if textID.text == "" {
            let alert = UIAlertController(title: "ID를 입력하세요", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true); return; }
        if textPassword.text == "" {
            let alert = UIAlertController(title: "PW를 입력하세요", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true); return; }
        if textName.text == "" {
            let alert = UIAlertController(title: "사용자 이름을 입력하세요", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true); return; }
        let passwordTest = NSPredicate(format: "SELF MATCHES %@","^(?=.*[A-Za-z])(?=.*\\d)[A-Za-z\\d]{7,}$")
        if !(passwordTest.evaluate(with: textPassword.text)) {
            let alert = UIAlertController(title: "Use at least one letter, one numeral, and seven characters.", message: "", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true)
            return;
        }
        let urlString: String = "http://condi.swu.ac.kr/student/T01iphone/login/insertUser.php"
        guard let requestURL = URL(string: urlString) else {
            return }
        var request = URLRequest(url: requestURL)
        request.httpMethod = "POST"
        let restString: String = "id=" + textID.text! + "&password=" + textPassword.text!
            + "&name=" + textName.text!
        request.httpBody = restString.data(using: .utf8)
        self.executeRequest(request: request)
    }
    @IBAction func buttonBack() {
        self.dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    //php파일, 경로확인

}
extension UIViewController {
    
    func showToast(message : String) {
        
        let toastLabel = UILabel(frame: CGRect(x: self.view.frame.size.width/2 - 75, y: self.view.frame.size.height-100, width: 180, height: 35))
        toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        toastLabel.textColor = UIColor.white
        toastLabel.textAlignment = .center;
        toastLabel.font = UIFont(name: "Montserrat-Light", size: 12.0)
        toastLabel.text = message
        toastLabel.alpha = 1.0
        toastLabel.layer.cornerRadius = 10;
        toastLabel.clipsToBounds  =  true
        self.view.addSubview(toastLabel)
        UIView.animate(withDuration: 4.0, delay: 0.1, options: .curveEaseOut, animations: {
            toastLabel.alpha = 0.0
        }, completion: {(isCompleted) in
            toastLabel.removeFromSuperview()
        })
    } }
