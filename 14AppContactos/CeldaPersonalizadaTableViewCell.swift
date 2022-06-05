//
//  CeldaPersonalizadaTableViewCell.swift
//  14AppContactos
//
//  Created by djdenielb on 04/06/22.
//

import UIKit

class CeldaPersonalizadaTableViewCell: UITableViewCell {
    @IBOutlet weak var ivFoto: UIImageView!
    @IBOutlet weak var labelNombre: UILabel!
    @IBOutlet weak var labelTelefono: UILabel!
    @IBOutlet weak var labelDireccion: UILabel!
    @IBOutlet weak var labelCorreo: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
