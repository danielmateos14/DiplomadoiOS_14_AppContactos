//
//  EditarViewController.swift
//  14AppContactos
//
//  Created by djdenielb on 03/06/22.
//

import UIKit

class EditarViewController: UIViewController {
    
    //  MARK: ***************************** variables *************************************
    var recibirNombre: String?
    var recibirTelefono: String?
    var recibirDireccion: String?
    var recibirCorreo: String?
    var recibirIndice: Int?

    //  MARK: ***************************** Outlets *************************************
    
    @IBOutlet weak var ivFoto: UIImageView!
    @IBOutlet weak var tfNombre: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tfNombre.text = recibirNombre
    }

    //  MARK: ***************************** Actions *************************************
    @IBAction func btnBarCamera(_ sender: UIBarButtonItem) {
    }
    
}
