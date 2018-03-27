//
//  ViewController.swift
//  Angular Acceleration
//
//  Created by Denis Bystruev on 27/03/2018.
//  Copyright © 2018 Denis Bystruev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var radiusLabel: UILabel!
    @IBOutlet weak var cyclesPerHourInputField: UITextField!
    
    @IBAction func cyclesPerHourChanged(_ sender: UITextField) {
        updateRadius()
    }
    
    // Editing finished — close the keyboard
    @IBAction func cyclesPerHourFinished(_ sender: UITextField) {
        cyclesPerHourInputField.resignFirstResponder()
        updateRadius()
    }
    
    // Enter is pressed — close the keyboard
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }

    // Touch outside of text fields — close the keyboard
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func updateRadius() {
        
        guard let text = cyclesPerHourInputField.text else {
            return
        }
        
        let dotText = text.replacingOccurrences(of: ",", with: ".")
        
        guard let cyclesPerHour = Float(dotText) else {
                return
        }
        
        let cyclesPerSecond = cyclesPerHour / 3600
        let radiansPerSecond = 2 * Float.pi * cyclesPerSecond
        
        let radiusText: String
        
        if abs(radiansPerSecond) < 0.0000000000000000001 {
            
            radiusText = "Infinity"
            
        } else {
            
            let acceleration: Float = 9.8
            let radius = acceleration / radiansPerSecond / radiansPerSecond
            
            if radius < 10 {
                radiusText = "\(radius) m"
            } else if radius < 10000 {
                radiusText = "\(lroundf(radius)) m"
            } else {
                radiusText = "\(lroundf(radius / 1000)) km"
            }
            
        }
        
        radiusLabel.text = "Radius: \(radiusText)"
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Ready to resize the view on keyboard appearance
        setupViewResizerOnKeyboardShown()
        
        cyclesPerHourInputField.delegate = self
        updateRadius()
    }

}


// Resize the view on keyboard appearance
// https://newfivefour.com/swift-ios-xcode-resizing-on-keyboard.html
// https://www.hackingwithswift.com/example-code/uikit/how-to-adjust-a-uiscrollview-to-fit-the-keyboard
extension UIViewController {
    
    @objc func keyboardWillResize(notification: Notification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue,
            let window = view.window?.frame {
            
            let height: CGFloat
            
            if notification.name == .UIKeyboardWillShow {
                // We're not just minusing the kb height from the view height because
                // the view could already have been resized for the keyboard before
                height = window.origin.y + window.height - keyboardSize.height
            } else {
                let viewHeight = view.frame.height
                height = viewHeight + keyboardSize.height
            }
            
            view.frame = CGRect(
                x: view.frame.origin.x,
                y: view.frame.origin.y,
                width: view.frame.width,
                height: height
            )
        }
    }
    
    func setupViewResizerOnKeyboardShown() {
        
        let names: [NSNotification.Name] = [
            .UIKeyboardWillShow,
            .UIKeyboardWillHide
        ]
        
        for name in names {
            NotificationCenter.default.addObserver(
                self,
                selector: #selector(keyboardWillResize),
                name: name,
                object: nil
            )
        }
    }
    
}
