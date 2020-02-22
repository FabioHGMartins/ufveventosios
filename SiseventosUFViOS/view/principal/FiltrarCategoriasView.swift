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
    
    @objc func atualizaSwitchCategoria(_ sender:UISwitch){
        let array = sender.restorationIdentifier!.components(separatedBy: "##")
        print(array[0], " ", array[1])  //id e nome
        
        if (sender.isOn == true){
            print("UISwitch state is now ON")
            
            UsuarioSingleton.shared.categoriasPref?.append(Categoria(array[0],array[1]))
            print("adicionei")
        }
        else{
            print("UISwitch state is now Off")
            
            for i in 0...UsuarioSingleton.shared.categoriasPref!.count {
                if (UsuarioSingleton.shared.categoriasPref![i].id == array[0]){
                    UsuarioSingleton.shared.categoriasPref!.remove(at: i)
                    print("deletei")
                    break
                }
            }
        }
    }
    
    @IBAction func aplicarFiltro() {
       //let aux = UsuarioSingleton.shared.categoriasPref
        //UsuarioSingleton.shared.categoriasPref = Array<Categoria>()
        
        for i in 0..<(cells?.count)! {
            if (cells![i].switcher?.isOn)! {
                
                //se uma categoria nova for selecionada alem das preferidas, sera adicionada na lista
                if(!(UsuarioSingleton.shared.categoriasPref?.contains(Categoria((cells![i].categoriaId),(cells![i].categoriaNome))))!){
                    UsuarioSingleton.shared.categoriasPref?.append(Categoria((cells![i].categoriaId),(cells![i].categoriaNome)))
                }
            }
        }
        
        //TODO: TESTE PARA VER CATEGORIAS PREFERIDAS
        let total = UsuarioSingleton.shared.categoriasPref?.count
        var i = 0
        while i < total!{
            print(UsuarioSingleton.shared.categoriasPref![i].nome, " - ", UsuarioSingleton.shared.categoriasPref![i].id)
            i = i + 1
        }
        print(" ")
    
        var ids = Array<String>()
        for cat in UsuarioSingleton.shared.categoriasPref! {
            ids.append(cat.id)
        }
        requester.putPreferenciasCategorias(idUsuario: (UsuarioSingleton.shared.usuario?.id)!, idCategorias: ids) { (ready,success) in
            if (ready) {
                if (!success) {
                    //UsuarioSingleton.shared.categoriasPref = aux
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
        
        cell.categoriaId = categoria.id
        cell.categoriaNome = categoria.nome
        
        //registra tag para switch e associa tratamento de evento
        cell.switcher?.restorationIdentifier = categoria.id + "##" + categoria.nome
        cell.switcher?.addTarget(self, action: #selector(atualizaSwitchCategoria(_:)), for: .valueChanged)
        
        cell.switcher?.isOn = (UsuarioSingleton.shared.categoriasPref?.contains(categoria))!
        
        //print("chamei celula", " - ", categoria.nome)
        
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
