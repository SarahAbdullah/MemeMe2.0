//
//  MemeEditorViewController.swift
//  MemeMe2.0
//
//  Created by Sarah on 11/13/18.
//  Copyright © 2018 Sarah. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController ,UIImagePickerControllerDelegate ,UINavigationControllerDelegate ,UITextFieldDelegate {

    
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var Share: UIBarButtonItem!
    
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var navigationBar: UINavigationBar!
    
        let imagePickerController = UIImagePickerController()
    let memeTextAttributes:[NSAttributedString.Key : Any] = [
        NSAttributedString.Key.strokeColor : UIColor.black,
        NSAttributedString.Key.foregroundColor : UIColor.white ,
        NSAttributedString.Key.font : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSAttributedString.Key.strokeWidth : -4.50 ]

    override func viewDidLoad() {
        super.viewDidLoad()
        textFieldFormat(textField : topTextField , initialText : "TOP" )
        textFieldFormat(textField : bottomTextField , initialText : "BOTTOM" )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        if imagePicker.image == nil {
            Share.isEnabled = false
        }
         subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField.text! == "TOP" || textField.text! == "BOTTOM" {
            textField.text = " "
        }
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true;
    }
    
    func textFieldFormat(textField : UITextField , initialText : String  ){
        textField.text = initialText
        textField.textAlignment = .center
        textField.backgroundColor = UIColor.clear
        textField.borderStyle = .none
        textField.defaultTextAttributes  = memeTextAttributes
        textField.delegate = self
        //to make the text in the center
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        textField.attributedText = NSAttributedString(string: initialText , attributes: [.paragraphStyle: paragraph])
    }

   
    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentImagePickerWith(sourceType: .photoLibrary)
    }

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]){
     // or imagePicker.image =  info[UIImagePickerController.InfoKey.originalImage] as? UIImage
        if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
        imagePicker.image = image
        }
       imagePicker.contentMode = .scaleAspectFit
        dismiss(animated: true, completion: nil)
        Share.isEnabled = true
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController){
        dismiss(animated: true, completion: nil)
    }

    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        presentImagePickerWith(sourceType: .camera)
    }
    
    func presentImagePickerWith(sourceType: UIImagePickerController.SourceType) {
        self.imagePickerController.delegate = self
        imagePickerController.sourceType = sourceType
        present(imagePickerController , animated: true, completion:nil )
        
    }
    
    @objc func keyboardWillShow( notification:Notification) {
   if (bottomTextField.isFirstResponder && self.view.frame.origin.y == 0)  {
         view.frame.origin.y -= getKeyboardHeight(notification)
               }
    }
    
    func getKeyboardHeight(_ notification:Notification) -> CGFloat {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue // of CGRect
        return keyboardSize.cgRectValue.height
    }
    
    func subscribeToKeyboardNotifications() {
    
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification , object: nil)
    }
    
    @objc func keyboardWillHide( notification:Notification) {
      if (bottomTextField.isFirstResponder ) {
        // view.frame.origin.y += getKeyboardHeight(notification)
        view.frame.origin.y = 0
        }
    }
    func unsubscribeFromKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self)
        
      // NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    //   NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)

    }

    func generateMemedImage() -> UIImage {
        
        //Hide toolbar and navbar
        hideTopAndBottomBars(true)
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        //Show toolbar and navbar
        hideTopAndBottomBars(false)
        return memedImage
    }
    
    func hideTopAndBottomBars(_ hide: Bool) {
        toolBar.isHidden = hide
        navigationBar.isHidden = hide    }
    
    func save(saveImage:UIImage ) {
        // Create the meme 
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imagePicker.image!, memedImage: saveImage)
        let object = UIApplication.shared.delegate
        let appDelegate = object as! AppDelegate
        appDelegate.memes.append(meme)
    } 
    
    
    @IBAction func sharePressed(_ sender: Any) {
        
        let memeImage = generateMemedImage()
        let controller = UIActivityViewController(activityItems: [memeImage], applicationActivities: nil )
        controller.completionWithItemsHandler = {
            //(activityType: UIActivity.ActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) in
            (activity, completed, items, error) in
            if(completed) {
                self.save(saveImage : memeImage)
                self.dismiss(animated: true, completion: nil)
            }
            
        }
        
        self.present(controller , animated: true , completion: nil )

    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        imagePicker.image = nil
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        Share.isEnabled = false
        dismiss(animated: false, completion: nil)
    }
 
}

