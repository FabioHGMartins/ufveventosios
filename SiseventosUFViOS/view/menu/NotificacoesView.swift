//
//  NotificacoesView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 02/07/19.
//  Copyright © 2019 Fabio Martins. All rights reserved.
//

import UIKit

class NotificacoesView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var margemView:UIView?
    
    @IBOutlet var notificacoesSwitch: UISwitch?
    @IBOutlet var agendaSwitch: UISwitch?
    
    @IBOutlet var tableView:UITableView?
    @IBOutlet var salvarBt:UIButton?
    @IBOutlet var progress:UIActivityIndicatorView?
    
    var cells:Array<CategoriaCell>?
    let requester = CategoriaRequester()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Notificações"
        
        let xib = UINib(nibName: "CategoriaCell", bundle: nil)
        self.tableView?.register(xib, forCellReuseIdentifier: "cell")
        
        
        requester.getCategoria() { (ready, success) in
            if(ready) {
                if (success) {
                    self.cells = Array<CategoriaCell>()
                    self.tableView?.reloadData()
                }
                self.progress?.stopAnimating()
            }
        }
        
        
    }
    
    @IBAction func salvar() {
        let aux = UsuarioSingleton.shared.categoriasNotf
        UsuarioSingleton.shared.categoriasNotf = Array<Categoria>()
        for i in 0..<(cells?.count)! {
            if (cells![i].switcher?.isOn)! {
                UsuarioSingleton.shared.categoriasNotf?.append(Categoria("\(i+1)",(cells![i].categoriaLb?.text)!))
            }
        }
        print(UsuarioSingleton.shared.categoriasNotf!)
        var ids = Array<String>()
        for cat in UsuarioSingleton.shared.categoriasNotf! {
            ids.append(cat.id)
        }
        requester.putPreferenciasNotificacoes(idUsuario: (UsuarioSingleton.shared.usuario?.id)!, idCategorias: ids) { (ready,success) in
            if (ready) {
                if (!success) {
                    UsuarioSingleton.shared.categoriasNotf = aux
                }
                self.navigationController?.popViewController(animated: true)
            }
            
        }
        UsuarioSingleton.shared.categoriasUpdate = true
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventosSingleton.shared.categorias.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cell") as! CategoriaCell     // Cast da célula para EventoCell
        let linha = indexPath.row
        let categoria = EventosSingleton.shared.categorias![linha]
        
        cells?.append(cell)
        
        cell.categoriaLb?.text = categoria.nome
        cell.switcher?.isOn = (UsuarioSingleton.shared.categoriasNotf?.contains(categoria))!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

}
