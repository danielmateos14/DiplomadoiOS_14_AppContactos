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
//    El indice recibe el indexpath de la table
//    creamos un array contacto que es igual a lo que trae el modelo de contactos como instancia
    var recibirNombre: String?
    var recibirTelefono: Int64?
    var recibirDireccion: String?
    var recibirCorreo: String?
    var recibirImagen: UIImage?
    var recibirIndice: Int = 0
    var arrayContactos =  [Contactos]()
    
//  MARK: ***************************** Conexion CoreData *************************************
//    Creamos la conexion del contexto
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
        
//        Traemos leer contactos para que se puedan modificar los contactos
        leerContactos()
//        Reemplazamos las variables graficas
        ivFoto.image = recibirImagen
        tfNombre.text = recibirNombre
        tfTelefono.text = "\(recibirTelefono ?? 0)"
        tfDireccion.text = recibirDireccion
        tfCorreo.text = recibirCorreo
        
        
        
        //  MARK: ******** funciones para agregar una imagen desde galeria o camara ****************
        //        Gestura de de la imagen, creamos una variable del tipo de la gestura, recibe
        //        parametros un self y una funcion de objective c que tenemos que crear
        //        despues el numero de toques y taps requeridos para que se inicie
        //        luego le decimos que la imagen se le van a añadir gestos y los habilitamos
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(clickImagen))
        gestureRecognizer.numberOfTouchesRequired = 1
        gestureRecognizer.numberOfTapsRequired = 1
        ivFoto.addGestureRecognizer(gestureRecognizer)
        ivFoto.isUserInteractionEnabled = true
        
    }
//        funcion para generar un vc que dentro sera la galeria, al cambiar el sourcetype
//        podemos poner que se abra la camara, aqui esta la funcion de objective c que tenemos que
//        crear, recibe como parametro al gestura de arriba y luego se crea una instancia de un
//        pickercontroller y con ese accedemos alos metodos sourcetype, delegate y allowsediting
//       sourcetype puede abrir el album o la camara, esta funcion sirve para abrir la galeria
//       del telefono o si cambiamos las opciones puede abrir la camara
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
    
//    la funcion leer contacto es igual que en el VC
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
    //        podemos poner que se abra la camara, esta es la misma que la de la galeria
    @IBAction func btnBarCamera(_ sender: UIBarButtonItem) {
        print("Debug ****** Tocar camara")
        let vc = UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true)
        
    }
//    EL boton aceptar primero crea un contexto y la conexion, despues con un do catch, guarda
//    en cada indicie del arregle, como nosotros nos trajimos el indice de la otra pantalla
//    ya sabemos en que posicion esta y sobre el array de esta pantalla que ya tiene los espacios
//    para llenarse con los datos del otro array de la otra pantalla entonces ahora usamos el
//    setValue que dice que lo que tengan las variables graficas de esta pantalla lo pongas en
//    los registros del CoreData por eso la key con el mismo nombre del coreData
//    Despues llamamos a conexto y save
//    El erro en el catch
//    Despues limpiamos todos los campos por si volvemos a entrar aqui esten vacios
//    Al final llamamos al bavigation para regresar a la otra pantalla
    @IBAction func btnAceptar(_ sender: UIButton) {
        let contexto = conexion()
        do{
            arrayContactos[recibirIndice].setValue(tfNombre.text, forKey: "nombre")
            arrayContactos[recibirIndice].setValue(Int64(tfTelefono.text ?? "999"), forKey: "telefono")
            arrayContactos[recibirIndice].setValue(tfDireccion.text, forKey: "direccion")
            arrayContactos[recibirIndice].setValue(tfCorreo.text, forKey: "correo")
            arrayContactos[recibirIndice].setValue(ivFoto.image?.pngData(), forKey: "imagen")
            
            try contexto.save()
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
//    Boton cancelar solo llama al navigation para regresar al VC
    @IBAction func btnCancelar(_ sender: UIButton) {
        navigationController?.popToRootViewController(animated: true)
    }
    
}

//  MARK: ***************************** extension para cambiar la imagen *****************************

//Esta extendion utiliza 2 protocolos para que aparezca la galeria y al seleccionar la imagen
//se pueda seleccionar y luego poder editarla haciendo zoom
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
