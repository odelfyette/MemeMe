//
//  ViewController.swift
//  MemeMe
//
//  Created by Octavius Delfyette on 9/11/17.
//  Copyright © 2017 Delfyette Designs. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController, UINavigationControllerDelegate {
    
    //MARK: Properties
    @IBOutlet weak var topToolBarControl: UIToolbar!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var imagePickerView: UIImageView!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var toolbarControl: UIToolbar!
    var memedImage: UIImage!
    
    let memeTextAttribute: [String: Any] = [
        NSStrokeColorAttributeName: UIColor.black,
        NSForegroundColorAttributeName: UIColor.white,
        NSFontAttributeName: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName: -2.0
    ]
    
    //MARK: LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextFields(topTextField, withString: "TOP")
        configureTextFields(bottomTextField, withString: "BOTTOM")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        subcribeToKeyboardNotificiations()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        unsubscribeToKeyboardNotifications()
    }
    
    //MARK: Configuration
    
    func configureTextFields(_ textField: UITextField, withString textString: String){
        textField.delegate = self
        textField.defaultTextAttributes = memeTextAttribute
        textField.text = textString
        textField.textAlignment = NSTextAlignment.center
    }
    
    func setSourceType(_ sourceType: UIImagePickerControllerSourceType){
        let pickerController = UIImagePickerController()
        pickerController.delegate = self
        pickerController.sourceType = sourceType
        self.present(pickerController, animated: true, completion: nil)
    }
    
    func setToolBarVisibility(isHidden: Bool){
        toolbarControl.isHidden = isHidden
        topToolBarControl.isHidden = isHidden
    }
    
    //MARK: Save and Cancel Actions
    
    @IBAction func cancel(_ sender: Any){
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        memedImage = nil
        imagePickerView.image = nil
        shareButton.isEnabled = false
    }
    
    func save(){
        if let topTest = topTextField.text{
            if let bottomText = bottomTextField.text{
                if let image = imagePickerView.image{
                    let meme = Meme(topText: topTest, bottomText: bottomText, originalImage: image, memedImage: generateMemedImage())
                    
                    (UIApplication.shared.delegate as! AppDelegate).memes.append(meme)
                }
            }
        }
    }
    
    //MARK: Image Actions
    
    @IBAction func pickAnImage(_ sender: Any) {
        setSourceType(.photoLibrary)
    }
    
    @IBAction func pickAnImageFromCamera(_ sender: Any) {
        setSourceType(.camera)
    }
    
    @IBAction func shareImage(_ sender: Any){
        memedImage = generateMemedImage()
        let shareController = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        shareController.completionWithItemsHandler = { (activityType: UIActivityType?, completed: Bool, returnedItems: [Any]?, error: Error?) -> Void in
            if completed == true {
                self.save()
                print("Saved")
            }
        }
        
        self.present(shareController, animated: true, completion: nil)
    }
    
    //MARK: Keyboard Actions
    
    func keyboardWillShow(notification: NSNotification){
        if bottomTextField.isFirstResponder{
            self.view.frame.origin.y = 0 - getKeyboardHeight(notification: notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification){
        self.view.frame.origin.y = 0
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        return keyboardSize.cgRectValue.height
    }
    
    func subcribeToKeyboardNotificiations(){
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillShow), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(MemeEditorViewController.keyboardWillHide), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications(){
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    //MARK: Meme Generator
    func generateMemedImage() -> UIImage{
        
        setToolBarVisibility(isHidden: true)
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        setToolBarVisibility(isHidden: false)
        
        return memedImage
    }
}

extension MemeEditorViewController: UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        textField.resignFirstResponder()
        return true
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if(textField.text == "TOP" || textField.text == "BOTTOM"){
            textField.text = ""
        }
    }
}

extension MemeEditorViewController: UIImagePickerControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        dismiss(animated: true, completion: nil)
        
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage{
            imagePickerView.image = image
            shareButton.isEnabled = true
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}

