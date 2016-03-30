//
//  PostImageViewController.swift
//  Raiz Pic
//
//  Created by Marco Linhares on 8/16/15.
//  Copyright (c) 2015 Marco. All rights reserved.
//

import UIKit
import Parse

class PostImageViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UITextFieldDelegate {

    var parseModel = ParseModel.singleton
    
    var photoSelected = false
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var imageView: UIImageView!
    
    @IBOutlet weak var textDescription: UITextField!
    
    @IBOutlet weak var labelErrorMessage: UILabel!
    
    @IBAction func buttonBack (sender: AnyObject) {
        dismissViewControllerAnimated (true, completion: nil)
    }
    
    @IBAction func buttonChooseImage(sender: AnyObject) {
        var imagePick = UIImagePickerController ()
        
        imagePick.delegate = self
        
        // pega da câmera do iPhone. No simulador dá erro e crasha o app
        //image.sourceType = UIImagePickerControllerSourceType.Camera
        
        // pega a imagem da galeria de fotos
        imagePick.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        
        // users cannot change the image (pan, crop)
        imagePick.allowsEditing = false
        
        // mostra a tela pro user escolher uma imagem
        self.presentViewController (imagePick, animated: true, completion: nil)
    }

    @IBAction func buttonPostImage(sender: AnyObject) {
        if photoSelected == false {
            labelErrorMessage.text = "Please select an image"
        } else if textDescription.text == "" {
            labelErrorMessage.text = "Please insert a text"
        } else {
            startLoading ()
            
            labelErrorMessage.text = ""
            
            parseModel.saveImageWeb (self.imageView.image!, textDescription: textDescription.text) {
                
                (result : Bool, error: NSError?) -> Void in
                
                if result == false {
                    self.labelErrorMessage.text = "Can't save the image"
                } else {
                    
                    // zera novamente as variáveis para um novo upload
                    self.labelErrorMessage.text = "Image uploaded with success!"
                    self.textDescription.text   = ""
                    
                    self.photoSelected = false
                    
                    self.imageView.image = UIImage (named: "picture")
                }
                
                // pára de carregar, dando certo ou não
                self.stopLoading ()
            }
        }
    }
    
    // função que é chamada depois que a imagem é escolhida
    func imagePickerController(picker: UIImagePickerController, didFinishPickingImage image: UIImage!, editingInfo: [NSObject : AnyObject]!) {
        
        // faz desaparecer a tela anterior que escolhe a imagem
        self.dismissViewControllerAnimated (true, completion: nil)
        
        imageView.image = image
        
        photoSelected = true
    }

    func startLoading () {
        activityIndicator.startAnimating ()
        
        // desabilita os cliques e outros eventos
        // porém, se fizer isso, trava tudo e não dá pra voltar
        UIApplication.sharedApplication ().beginIgnoringInteractionEvents ()
    }
    
    func stopLoading () {
        self.activityIndicator.stopAnimating ()
        
        UIApplication.sharedApplication ().endIgnoringInteractionEvents ()
    }
    
    // ocorre quando a pessoa clica na tela
    // serve para tirar o teclado e não atrapalhar a UX
    override func touchesBegan (touches: Set <NSObject>, withEvent event: UIEvent) {
        
        // pára de editar, o que significa que o teclado desaparece
        self.view.endEditing (true)
    }
    
    // called when 'return' key pressed. return NO to ignore.
    // é chamado quando o user aperta o botão <enter> do teclado do app
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing (true)
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
