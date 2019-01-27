//
//  ViewController.swift
//  MemeMe
//
//  Created by Alsuhaibani on 16/11/2018.
//  Copyright © 2018 Alsuhaibani. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UIImagePickerControllerDelegate,UINavigationControllerDelegate, UITextFieldDelegate {
    
   

    @IBOutlet weak var topBar: UIToolbar!
    @IBOutlet weak var buttomBar: UIToolbar!
    
    @IBOutlet weak var topText: UITextField!
    @IBOutlet weak var buttomText: UITextField!
    
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    
    var textFieldTag: Int = 0
    
    override func viewDidLoad() {
       super.viewDidLoad()
        
       topText.text = "Top"
       buttomText.text = "Buttom"
       topText.delegate = self
       buttomText.delegate = self
       
       prepareTextField(textField: topText, defaultText:"TOP")
       prepareTextField(textField: buttomText, defaultText:"BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(ViewController.keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(ViewController.keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
        
    }
    // MARK: Keyboard Setting

    @objc func keyboardWillShow(_ notification:Notification) {
            if textFieldTag == 1 && self.view.frame.origin.y == 0 {
           view.frame.origin.y = -getKeyboardHeight(notification)
        }
    }
    
    @objc func keyboardWillHide(_ notification:Notification) {
        view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        
        let keyboardFrame: NSValue = notification.userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        let keyboardRectangle = keyboardFrame.cgRectValue
        let keyboardHeight = keyboardRectangle.height
        
        return keyboardHeight
    }
     // MARK: Font Style
    
        let strokeTextAttributes: [NSAttributedString.Key: Any] = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white,
        .strokeWidth : -2,
        .font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40 )!,
    ] as [NSAttributedString.Key : Any]
  
    // MARK: textField Setting
    
    func prepareTextField(textField: UITextField, defaultText: String) {
        topText.defaultTextAttributes = strokeTextAttributes
        buttomText.defaultTextAttributes = strokeTextAttributes
        topText.textAlignment = .center
        buttomText.textAlignment = .center
       // topText.adjustsFontSizeToFitWidth = true
       // buttomText.adjustsFontSizeToFitWidth = true
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        self.textFieldTag = textField.tag
        return true
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.tag == 0 { topText.text = "" }
        if textField.tag == 1 { buttomText.text = "" }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return true
    }
    func pickImage(sourceType: UIImagePickerController.SourceType){
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        present(imagePicker, animated: true, completion: nil)
    }
    @IBAction func pickAnImage(_ sender: Any) {
      pickImage(sourceType: .photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
      pickImage(sourceType: .camera)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage{
            imagePickerView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
   
    // MARK: generate Meme
    
    @IBAction func cancelButton(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
        
    }
    @IBAction func shareImg(_ sender: Any) {
        
        let memedImage = generateMeme()
        
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        shareController.completionWithItemsHandler = { (activityType, completed, returnedItems, activityError) -> Void in
            if (completed) {
                self.save(memedImage: memedImage)
                //Dismiss the shareActivityViewController
                self.dismiss(animated: true, completion: nil)
            }
        }
        
        present(shareController, animated: true, completion: nil)
    }
    
    
    func generateMeme() -> UIImage {
        
        self.topBar.isHidden = true
        self.buttomBar.isHidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        self.topBar.isHidden = false
        self.buttomBar.isHidden = false
        
        return memedImage
    }
    func save(memedImage: UIImage) {
        // Create the meme
        let meme = Meme(top: topText.text!, bottom: buttomText.text!, image: imagePickerView.image, memedImage: memedImage)
        
        // Add it to the memes array in the Application Delegate
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    }
}
    




