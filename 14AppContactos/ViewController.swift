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
//    El indice aqui sirve para mandar cuando se seleccione el row tambien mandamos la posicion
    var indiceEnviar: Int = 0
    
//  MARK: **************************************** CoreData *************************************
//    Declaramos un array del tipo de la entidad de coredata con el mismo
//    nombre, para irlo llenando
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
        
//        Llamada a la funcion de leer de coreData, para que al momento de guardar los cambios
//        vuelva a leer coredata y los muestre
        leerContacto()
        
//        Registro de la celda personalizada
        tabla.register(UINib(nibName: "CeldaPersonalizadaTableViewCell", bundle: nil), forCellReuseIdentifier: "celda")
    //  MARK: *********** Delegados **********
        tabla.delegate = self
        tabla.dataSource = self
}
    
//  MARK: ***************************** ViewWillApear **********************************************
//    Cuando guardamos los cambios en la pantalla de editar, al regresar aqui esos datos no se ven
//    por que hay que recargar la tabla y para eso esta funcion, al momento que aparece
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
//    Esta funcion instancia la funcion de arriba de conexion, despues se crea una variable del
//    tipo nsfetc, que es para obtener la informacion del modelo ya lleno con su diferente row
//    eso es igual a el modelo lleno
//    despues se hace un do con un try dice que intente sobre la variable contexto obtener lo que
//    traiga la variable fetchrequest y la variable ya trae el modelo lleno
//    si no sale imprimimos el erro
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
//        Al boton de agregar contacto que esta en la uibarbutton le vamos a crear una alert
//        con unos textfield para poder crear un contacto nuevo, cada textfield llenara cada campo
//        del coredata
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
        
//        Al momento de dar al boton aceptar de la alerta, creamos unas variables seguras con los
//        datos que trae cada textfield el de la imagen es data y el del telefono es int64
        let buttonAceptar = UIAlertAction(title: "Aceptar", style: .default) { UIAlertAction in
            //  MARK: **** guardar valores de los tf de la alerta  *******
            guard let nombreAlerta = alert.textFields?[0].text else {return}
            guard let telefonoAlerta = Int64(alert.textFields?[1].text ?? "0") else {return}
            guard let direccionAlerta = alert.textFields?[2].text else {return}
            guard let correoAlerta = alert.textFields?[3].text else {return}
            let imagenTemporal = UIImageView(image: UIImage(systemName: "person.fill"))
            
//            Las variables del text edit las vamos a guardar en coredata, ahora creamos al context
//            e instanciamos la funcion conexion, despues creamos una variable que sera del tipo
//            del modelo de Coredata y recibe como parametros al contexto que es el que acabamos
//            de crear y a su ves es una instancia de la funcion conexion, ahora la variable
//            nuevocontacto tiene acceso a los registros del coreData, accedemos a cada uno de ellos
//            y le asignamos lo que tiene cada variable segura de arriba, en imagen hay que poner
//            png data
            let contexto = self.conexion()
            let nuevoContacto = Contactos(context: contexto)
            nuevoContacto.nombre = nombreAlerta
            nuevoContacto.telefono = telefonoAlerta
            nuevoContacto.direccion = direccionAlerta
            nuevoContacto.correo = correoAlerta
            nuevoContacto.imagen = imagenTemporal.image?.pngData()
            
//            sobre el array le ponemos el append para que lo agregue en cada indice, nuevocontacto
//            ya viene lleno con lo que escribimos en los texfield y ahora con append se agrega
//            al indice 0 el nuevocontacto lleno
//            despues llamamos a guardarcontacto y luego recargamos la tablita
            self.arrayPruebaContactos.append(nuevoContacto)
            self.guardarContacto()
            self.tabla.reloadData()
        }
//        boton cancelar solo cierra la alerta
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
//        Aqui podemos desempaquetar la imagen por que ya le pusimos valor por defecto arriba en las
//        variables seguras
        celda.ivFoto.image = UIImage(data: arrayPruebaContactos[indexPath.row].imagen!)
        
        return celda
    }
    
    //  MARK: ********* Acciones para deslizar ********
//    Estas acciones aparecen al deslizar a la derecha o izquierda, leading izquierda, trailing dere
//    creamos una variable del tipo  contextualaction y ponemos los guiones necesarios de los
//    parametros y luego el closure, dentro del closure creamos a contexto y llamamos a conexion
//    despues con contexto a delete y dentro de delete ponemos el indexpath del array
//    eso lo elimina del coredata pero hay que eliminarlo de la tablita, eso lo hacemos con
//    el array remove y el indexpath, luego llamamos a guardar contacto  y luego recargamos la tabla
//    Despues con personzalizamos la variable con una imagen y con un color, al final retornamos
//    la variable
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "") { _, _, _ in
            print("Debug ****** eliminar ")
            
            
//      Eliminar registro en core data al eliminarlo de la tableView
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
//    Aqui cuando deslize a la derecha vamos hacer o una llamada o mandar un correo
//    ............
//    al final cuando retornamos la variable, la tenemos que poner junto a la otra separada por ,
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
//        Enviamos el indice para saber que row se selecciono
        indiceEnviar = indexPath.row
        
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
