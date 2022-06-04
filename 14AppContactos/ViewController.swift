//
//  ViewController.swift
//  14AppContactos
//
//  Created by djdenielb on 03/06/22.
//

import UIKit

class ViewController: UIViewController {
    
    //  MARK: ***************************** Variables *************************************
    var nombreEnviar: String?
    let arrayPruebaContactos: [String] = ["1","2","3"]

    
//  MARK: ***************************** Outlets *************************************
    @IBOutlet weak var tabla: UITableView!

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    //  MARK: ***************************** Delegados *************************************    }
        tabla.delegate = self
        tabla.dataSource = self

}
    
    //  MARK: ***************************** Actions *************************************
    @IBAction func btnBarAdd(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Agregar", message: "Agregar nuevo contacto", preferredStyle: .actionSheet)
        
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
            guard let telefonoAlerta = alert.textFields?[1].text else {return}
            guard let direccionAlerta = alert.textFields?[2].text else {return}
            guard let correoAlerta = alert.textFields?[3].text else {return}
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
        let celda = tabla.dequeueReusableCell(withIdentifier: "celda", for: indexPath)
        
        celda.textLabel?.text = arrayPruebaContactos[indexPath.row]
        celda.detailTextLabel?.text = "2323232323232"
        celda.imageView?.image = UIImage(systemName: "person")
        
        return celda
    }
    
    //  MARK: ********* Acciones para deslizar ********
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let accionEliminar = UIContextualAction(style: .normal, title: "") { _, _, _ in
            print("Debug ****** eliminar ")
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
        print(arrayPruebaContactos[indexPath.row])
        
        nombreEnviar = arrayPruebaContactos[indexPath.row]
        
        performSegue(withIdentifier: "segueDetalles", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "segueDetalles" {
            let enviarDatos = segue.destination as! EditarViewController
            enviarDatos.recibirNombre = nombreEnviar
            enviarDatos.recibirTelefono
            enviarDatos.recibirDireccion
            enviarDatos.recibirCorreo
        }
    }
}
