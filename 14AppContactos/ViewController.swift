//
//  ViewController.swift
//  14AppContactos
//
//  Created by djdenielb on 03/06/22.
//

import UIKit
import CoreData

class ViewController: UIViewController {
    
//  MARK: *************************************** Variables *************************************
    var nombreEnviar: String?
    var telefonoEnviar: Int64?
    var direccionEnviar: String?
    var correoEnviar: String?
    var imagenEnviar: UIImage?
//    var imagenEnviar: UIImage = UIImage(systemName: "person")
    var indiceEnviar: Int = 0
    
//  MARK: **************************************** CoreData *************************************
//    Declaramos un array del tipo de la entidad de coredata con el mismo
//    nombre
    var arrayPruebaContactos: [Contactos] = []
    
//    1 - Agregar la conexion, por medio de una funcion, esta funcion NSObjectContext
//        creara un registro en la tabla de coreData, haremos una conexion a ese registro
    func conexion() -> NSManagedObjectContext{
//        Declaramos un delegado que traera las funciones desde al appDelegate donde viene ya
//        coreData
        let delegate = UIApplication.shared.delegate as! AppDelegate
//        Retornamos ese delegate ya con las funciones que trajo desde el APPDelegate
        return delegate.persistentContainer.viewContext
    }

    
//  MARK: ***************************** Outlets *************************************
    @IBOutlet weak var tabla: UITableView!

    
//  MARK: ************************************** ViewDidLoad *************************************
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        Llamada a la funcion de leer de coreData
        leerContacto()
        tabla.register(UINib(nibName: "CeldaPersonalizadaTableViewCell", bundle: nil), forCellReuseIdentifier: "celda")
    //  MARK: *********** Delegados **********
        tabla.delegate = self
        tabla.dataSource = self
}
    
//  MARK: ***************************** ViewWillApear **********************************************
    override func viewWillAppear(_ animated: Bool) {
        tabla.reloadData()
    }
    
//  MARK: ************************ guardar contacto en core data *************************************
//    Creamos una funcion para guardar en core data, una instancia de la funcion que se creo
//    arriba y dentro de esta funcion de guadar, hacer un do catch si hay un error, imprime
//    y si no hay error entonces intenta traer la instancia de la funcion de arriba y usa el
//    metodo salvar, recuerda que la funcion de arriba se trae los metodos del APPDelegate por
//    eso es que aqui podemos usar el .save
    func guardarContacto(){
        let contexto = conexion()
        do{
            try contexto.save()
        }catch let error as NSError{
            print("Error al guardar en core data \(error.localizedDescription)")
        }
    }
    
//  MARK: ************************ leer contacto en core data *************************************
    func leerContacto(){
        let contexto = conexion()
        let fetchRequest: NSFetchRequest<Contactos> = Contactos.fetchRequest()
        do{
            arrayPruebaContactos = try contexto.fetch(fetchRequest)
        }catch{
            print("Error al leer la base de datos \(error.localizedDescription)")
        }
    }
    
//  MARK: ***************************** Actions *************************************
    @IBAction func btnBarAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Agregar", message: "Agregar nuevo contacto", preferredStyle: .alert)
        
        //  MARK: ****** Agregar text field al alert *******
        alert.addTextField { (nombreTF) in
            nombreTF.placeholder = "Nombre"
            nombreTF.textColor = .blue
        }
        
        alert.addTextField { (telefonoTF) in
            telefonoTF.placeholder = "Telefono"
            telefonoTF.keyboardType = .numberPad
        }
        
        alert.addTextField { (direccionTF) in
            direccionTF.placeholder = "Direccion"
            direccionTF.textColor = .blue
        }
        
        alert.addTextField { (emailTF) in
            emailTF.placeholder = "Correo Electronico"
            emailTF.keyboardType = .emailAddress
        }
        
        
        let buttonAceptar = UIAlertAction(title: "Aceptar", style: .default) { UIAlertAction in
            //  MARK: **** guardar valores de los tf de la alerta  *******
            guard let nombreAlerta = alert.textFields?[0].text else {return}
            guard let telefonoAlerta = Int64(alert.textFields?[1].text ?? "0") else {return}
            guard let direccionAlerta = alert.textFields?[2].text else {return}
            guard let correoAlerta = alert.textFields?[3].text else {return}
            let imagenTemporal = UIImageView(image: UIImage(systemName: "person.fill"))
            
//            Las variables del text edit las vamos a guardar en coredata
            let contexto = self.conexion()
            let nuevoContacto = Contactos(context: contexto)
            nuevoContacto.nombre = nombreAlerta
            nuevoContacto.telefono = telefonoAlerta
            nuevoContacto.direccion = direccionAlerta
            nuevoContacto.correo = correoAlerta
            nuevoContacto.imagen = imagenTemporal.image?.pngData()
            
            self.arrayPruebaContactos.append(nuevoContacto)
            self.guardarContacto()
            self.tabla.reloadData()
        }
        let buttonCancelar = UIAlertAction(title: "Cancelar", style: .destructive)
        
        alert.addAction(buttonAceptar)
        alert.addAction(buttonCancelar)
        present(alert, animated: true)
    }
}

//  MARK: ***************************** tableView *************************************

extension ViewController: UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPruebaContactos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let celda = tabla.dequeueReusableCell(withIdentifier: "celda", for: indexPath) as! CeldaPersonalizadaTableViewCell
        
        celda.labelNombre.text = arrayPruebaContactos[indexPath.row].nombre
        celda.labelTelefono.text = "\(arrayPruebaContactos[indexPath.row].telefono)"
        celda.labelDireccion.text = arrayPruebaContactos[indexPath.row].direccion
        celda.labelCorreo.text = arrayPruebaContactos[indexPath.row].correo
//        let imageData =
//        let imagenData = UIImage(data: arrayPruebaContactos[indexPath.row].imagen ?? )
//        print(arrayPruebaContactos[indexPath.row].imagen)
        celda.ivFoto.image = UIImage(data: arrayPruebaContactos[indexPath.row].imagen!)
        //        celda.ivFoto.image = arrayPruebaContactos[indexPath.row].imagen
        //        celda.imageView?.image = UIImage(data: arrayPruebaContactos[indexPath.row].imagen!)
        
        return celda
    }
    
    //  MARK: ********* Acciones para deslizar ********
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "") { _, _, _ in
            print("Debug ****** eliminar ")
            
            
//            Eliminar registro en core data al eliminarlo de la tableView
            let contexto = self.conexion()
            contexto.delete(self.arrayPruebaContactos[indexPath.row])
    //  Eliminar contacto de la tabla
            self.arrayPruebaContactos.remove(at: indexPath.row)
            self.guardarContacto()
            self.tabla.reloadData()
        }
        accionEliminar.image = UIImage(systemName: "trash")
        accionEliminar.backgroundColor = UIColor.red
        
        return UISwipeActionsConfiguration(actions: [accionEliminar])
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionCorreo = UIContextualAction(style: .normal, title: "") { _, _, _ in
            print("Debug ****** correo")
        }
        accionCorreo.image = UIImage(systemName: "mail")
        accionCorreo.backgroundColor = UIColor.blue
        
        let accionLlamada = UIContextualAction(style: .normal, title: "") { _, _, _ in
            print("Debug ****** llamada")
        }
        accionLlamada.image = UIImage(systemName: "phone")
        accionLlamada.backgroundColor = UIColor.green
        
        return UISwipeActionsConfiguration(actions: [accionCorreo, accionLlamada])
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        nombreEnviar = arrayPruebaContactos[indexPath.row].nombre
        telefonoEnviar = arrayPruebaContactos[indexPath.row].telefono
        direccionEnviar = arrayPruebaContactos[indexPath.row].direccion
        correoEnviar = arrayPruebaContactos[indexPath.row].correo
        imagenEnviar = UIImage(data: arrayPruebaContactos[indexPath.row].imagen!)
        indiceEnviar = indexPath.row
        
//        print("Debug ****** \(indiceEnviar ?? 0)")
        
        
        performSegue(withIdentifier: "segueDetalles", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetalles" {
            let enviarDatos = segue.destination as! EditarViewController
            enviarDatos.recibirNombre = nombreEnviar
            enviarDatos.recibirTelefono = telefonoEnviar
            enviarDatos.recibirDireccion = direccionEnviar
            enviarDatos.recibirCorreo = correoEnviar
            enviarDatos.recibirImagen = imagenEnviar
            enviarDatos.recibirIndice = indiceEnviar
        }
    }
}
