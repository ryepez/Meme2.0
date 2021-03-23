//
//  ViewController.swift
//  MemeMe1.0
//
//  Created by Ramon Yepez on 3/8/21.
//

import UIKit

class ViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UIScrollViewDelegate {
    
    //outlets
    @IBOutlet weak var imageV: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var topTextField: UITextField!
    @IBOutlet weak var bottomTextField: UITextField!

    @IBOutlet weak var shareButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var toolBarTop: UIToolbar!
    @IBOutlet weak var toolBarBottom: UIToolbar!
    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting textfields inital text and style with a function named textSetup
        
        //top textfield
        textSetup(textfiled: topTextField, initialText: "TOP")

        //bottom textField
        textSetup(textfiled: bottomTextField, initialText: "BOTTOM")
      //scrolling view
        scrollView.delegate = self
        scrollView.minimumZoomScale = 1.0
        scrollView.maximumZoomScale = 10.0
       
        //making the toolbars a little transparent
        toolBarTop.alpha = 0.9
        toolBarBottom.alpha = 0.9

    }
    
 
    
    override func viewWillAppear(_ animated: Bool) {
        //initial seeting to disable the camera button if the device does not have one
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
        
        // function that disable the share and delete buttons if no picture has been selected
        shareAndDeleteEnable()
        
        // notifications to key track of the keyboard
        subscribeToKeyboardNotifications()
        subscribeToKeyboardNotificationsHide()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        unsubscribeToKeyboardNotifications()
        unsubscribeToKeyboardNotificationsHide()

    }
    
    @IBAction func imagePicker(_ sender: UIBarButtonItem) {
        //unwrapping the optional for button title
        if let source = sender.title {
            // creating an instance of pickercontroller
            let imagePicker = UIImagePickerController()
            //setting the delegate for image picker
            imagePicker.delegate = self
            
            //switch to assign it based on source
            switch source {
            case "Album":
            imagePicker.sourceType = .photoLibrary
            case "Camera":
            imagePicker.sourceType = .camera
            default:
                print("something went wrong :(")
            }
            //present the image picker
            present(imagePicker, animated: true, completion: nil)
        }
      
    }
    
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // getting the image selected by the user
        if let image = info[.originalImage] as? UIImage {
            //assigning the image to be display on our view
            imageV.image = image
        }
        // enabling the share button if image is not nil
        shareAndDeleteEnable()

        //dismissing the picker
        dismiss(animated: true, completion: nil)

    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        //dismissing the picker
        dismiss(animated: true, completion: nil)
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
       //when the user tap the text clear out
        textField.text = ""
    
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // when the user press return the keyboard disappear
        textField.resignFirstResponder()
        return true
    }
    
    
   // keyboard Setting
  @objc  func keyboardWiShow(_ notification:Notification) {
    // if statement to only do the movement of keyboard when is the bottom textfield
    if bottomTextField.isEditing, view.frame.origin.y == 0  {
        view.frame.origin.y -= getKeyboardHeight(notification)
    }
    
    }
    
    //function that gets the height of the keyboard
    func getKeyboardHeight(_ notification:Notification) -> CGFloat  {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIResponder.keyboardFrameEndUserInfoKey] as! NSValue
        
        return keyboardSize.cgRectValue.height
    }
    
    //keyboard subscriptions
    func subscribeToKeyboardNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWiShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
    }
    
    //hidding keyboard
    
    @objc func keyboardWillHide(_ notification:Notification) {
        //return the view to it is orginal point if the view is not at zero
        
        if  bottomTextField.isEditing, view.frame.origin.y != 0 {
            view.frame.origin.y = 0
        }
        
}
    
    func subscribeToKeyboardNotificationsHide() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeToKeyboardNotificationsHide() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
  
    func save() {
            // Create the meme
        let meme = Meme(topText: topTextField.text!, bottomText: bottomTextField.text!, originalImage: imageV.image!, memedImage: generateMemedImage())
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.memes.append(meme)
    }
    
    //creating the meme image
    
func generateMemedImage() -> UIImage {

        //Hide toolbar
        toolBarTop.isHidden = true
        toolBarBottom.isHidden = true
        // Render view to an image
        UIGraphicsBeginImageContext(self.view.frame.size)
        view.drawHierarchy(in: self.view.frame, afterScreenUpdates: true)
        let memedImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        //Show toolbar
        toolBarTop.isHidden = false
        toolBarBottom.isHidden = false

        return memedImage
    }
  
    
@IBAction  func share() {
    
        //generate a memed image
        let generatedMeme = generateMemedImage()
    
        //defining an instance of the ActivityViewController and passing the  generatedMeme as an activity item
        let shareController = UIActivityViewController(activityItems: [generatedMeme], applicationActivities: nil)
    //presenting
    self.present(shareController, animated: true, completion: nil)
//saving the meme and dimissing the activity view controller
    shareController.completionWithItemsHandler = {
        (activity, completed, items, error) in
        if completed {
        self.save()
        self.dismiss(animated: true, completion: nil)

        }
        self.dismiss(animated: true, completion: nil)
        }
            }
    
    func shareAndDeleteEnable() {
        shareButton.isEnabled = (imageV.image == nil) ? false: true
        deleteButton.isEnabled = (imageV.image == nil) ? false: true
    }
    
    @IBAction func deleteMeme(_ sender: UIButton) {
    
        //setting the textfields and image to initial stage
        topTextField.text = "TOP"
        bottomTextField.text = "BOTTOM"
        imageV.image = nil
        
        // disabling the share button
        shareAndDeleteEnable()

            }
    // function to zoom the picture
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageV
    }

    @IBAction func goBack(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
