//
//  ViewController.swift
//  Swisp
//
//  Created by Adam Spindler on 2/11/16.
//  Copyright © 2016 Adam Spindler. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate
{
    @IBOutlet weak var txtConsole: UITextView!
    @IBOutlet weak var txtInput: UITextField!
    
    var interpreter: Interpreter = Interpreter()
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        txtInput.delegate = self
        
        // controls the movement of the view when the keyboard pops up
        // in the simulator when you use the computer keyboard it messes up and moves the view incorrectly so
        // uncomment the lines for actual use
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }

    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func btnEvaluatePressed(sender: AnyObject)
    {
        evaluateExpression()
    }
    
    func keyboardWillShow(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.view.frame.origin.y -= keyboardSize.height
        }
    }
    
    func keyboardWillHide(notification: NSNotification)
    {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
        {
            self.view.frame.origin.y += keyboardSize.height
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool
    {
        evaluateExpression()
        
        return true
    }
    
    func evaluateExpression()
    {
        var attrExpressionStr: NSMutableAttributedString = NSMutableAttributedString(attributedString: txtConsole.attributedText!)
        attrExpressionStr.appendAttributedString(NSAttributedString(string: "\r\n\r\n> " + txtInput.text! + "\r\n"))
        
        do
        {
            attrExpressionStr.appendAttributedString(try interpreter.evaluteToAttributedString(txtInput.text!))
        }
        catch
        {
            attrExpressionStr.appendAttributedString(NSAttributedString(string: "Error"))
        }
        
        defer
        {
            // update the UI
            txtConsole.attributedText = attrExpressionStr
            txtInput.text = ""
            
            // scroll to the bottom of the console
            txtConsole.layoutIfNeeded()
            txtConsole.scrollRangeToVisible(NSMakeRange(txtConsole.text.characters.count - 1, 1))
        }
    }
}

