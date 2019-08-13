//
//  FiltrarCategoriasView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 28/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit

class FiltrarCategoriasView: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableView:UITableView?
    @IBOutlet var aplicarBt:UIButton?
    @IBOutlet var progress:UIActivityIndicatorView?
    
    @IBOutlet var margemView:UIView?
    
    var cells:Array<CategoriaCell>?
    let requester = CategoriaRequester()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Escolher Categorias"
        
        //back button white color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let voltarBt = UIBarButtonItem()
        voltarBt.title = "Voltar"
        self.navigationController?.navigationItem.backBarButtonItem = voltarBt
        
        
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
    
    @IBAction func aplicarFiltro() {
        let aux = UsuarioSingleton.shared.categoriasPref
        UsuarioSingleton.shared.categoriasPref = Array<Categoria>()
        for i in 0..<(cells?.count)! {
            if (cells![i].switcher?.isOn)! {
                UsuarioSingleton.shared.categoriasPref?.append(Categoria("\(i+1)",(cells![i].categoriaLb?.text)!))
            }
        }
        print(UsuarioSingleton.shared.categoriasPref!)
        var ids = Array<String>()
        for cat in UsuarioSingleton.shared.categoriasPref! {
            ids.append(cat.id)
        }
        requester.putPreferenciasCategorias(idUsuario: (UsuarioSingleton.shared.usuario?.id)!, idCategorias: ids) { (ready,success) in
            if (ready) {
                if (!success) {
                    UsuarioSingleton.shared.categoriasPref = aux
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
        cell.switcher?.isOn = (UsuarioSingleton.shared.categoriasPref?.contains(categoria))!
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let linha = indexPath.row
        let evento = EventosSingleton.shared.categorias![linha]

        //        let vc = DetalhesCarroViewController(nibName: "DetalhesCarroViewController", bundle: nil)
        //        vc.carro = carro
        //        self.navigationController!.pushViewController(vc, animated: false)
        
    }

}
