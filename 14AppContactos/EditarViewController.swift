//
//  EditarViewController.swift
//  14AppContactos
//
//  Created by djdenielb on 03/06/22.
//

import UIKit
import CoreData

class EditarViewController: UIViewController {
    
//  MARK: ***************************** variables *************************************
    
    var recibirNombre: String?
    var recibirTelefono: Int64?
    var recibirDireccion: String?
    var recibirCorreo: String?
    var recibirImagen: UIImage?
    var recibirIndice: Int = 0
    var arrayContactos =  [Contactos]()
    
//  MARK: ***************************** Conexion CoreData *************************************
            func conexion() -> NSManagedObjectContext{
                let delegate = UIApplication.shared.delegate as! AppDelegate
                return delegate.persistentContainer.viewContext
            }
    
    //  MARK: ***************************** Outlets *************************************
    
    @IBOutlet weak var ivFoto: UIImageView!
    @IBOutlet weak var tfNombre: UITextField!
    @IBOutlet weak var tfTelefono: UITextField!
    @IBOutlet weak var tfCorreo: UITextField!
    @IBOutlet weak var tfDireccion: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        leerContactos()
        
//        print("Debug ****** \(recibirImagen)")
        ivFoto.image = recibirImagen
        tfNombre.text = recibirNombre
        tfTelefono.text = "\(recibirTelefono ?? 0)"
        tfDireccion.text = recibirDireccion
        tfCorreo.text = recibirCorreo
        
        
        
        //  MARK: ******** funciones para agregar una imagen desde galeria o camara ****************
            //        Gestura de de la imagen
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        ivFoto.addGestureRecognizer(gestureRecognizer)
        ivFoto.isUserInteractionEnabled = true
        
    }
//        funcion para generar un vc que dentro sera la galeria, al cambiar el sourcetype
//        podemos poner que se abra la camara
    @objc func clickImagen(recibeGestura: UITapGestureRecognizer){
        print("Debug ****** Tocar imagen")
        let vc = UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
    }
    
    //Ocultar teclado
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    
    func leerContactos() {
        let contexto = conexion()
        let fetchRequest : NSFetchRequest<Contactos> = Contactos.fetchRequest()
        do {
            arrayContactos = try contexto.fetch(fetchRequest)
            print(arrayContactos.count)
            print(arrayContactos)
        }catch {
            print("Error al leer informacion de la bd de coredata: \(error.localizedDescription)")
        }
    }

//  MARK: ********************************** Actions ************************************************
    
//    //        funcion para generar un vc que sera la camara, al cambiar el sourcetype
    //        podemos poner que se abra la camara
    @IBAction func btnBarCamera(_ sender: UIBarButtonItem) {
        print("Debug ****** Tocar camara")
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
    @IBAction func btnAceptar(_ sender: UIButton) {
        let contexto = conexion()
        do{
            arrayContactos[recibirIndice].setValue(tfNombre.text, forKey: "nombre")
            arrayContactos[recibirIndice].setValue(Int64(tfTelefono.text ?? "999"), forKey: "telefono")
            arrayContactos[recibirIndice].setValue(tfDireccion.text, forKey: "direccion")
            arrayContactos[recibirIndice].setValue(tfCorreo.text, forKey: "correo")
            arrayContactos[recibirIndice].setValue(ivFoto.image?.pngData(), forKey: "imagen")
            
            try contexto.save()
//            print("Debug array indice ****** \(arrayContactos[0])")
//            print("Debug indice vc ****** \(recibirIndice)")
            print("Se guardo correctamente")
            
        }catch{
            print("error al guardar\(error.localizedDescription)")
        }
        
        tfNombre.text = ""
        tfTelefono.text = ""
        tfDireccion.text = ""
        tfCorreo.text = ""
        navigationController?.popViewController(animated: true)
        
    }
    @IBAction func btnCancelar(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

//  MARK: ***************************** extension para cambiar la imagen *****************************

extension EditarViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate{
    
//    Usuario puede seleccionar una imagen al presionar en la foto
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let imagenSeleccionada = info[UIImagePickerController.InfoKey(rawValue: "UIImagePickerControllerEditedImage")] as? UIImage {
            ivFoto.image = imagenSeleccionada
        }
        picker.dismiss(animated: true)
    }
    
//  El usuario cancela
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}
