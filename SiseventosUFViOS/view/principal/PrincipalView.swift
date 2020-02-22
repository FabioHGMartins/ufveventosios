//
//  PrincipalView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 21/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController

class PrincipalView: UIViewController {
    
    @IBOutlet var filtrarBt:UIButton?
    @IBOutlet var tableView:UITableView?
    
    @IBOutlet var margemView:UIView?

    @IBOutlet var progress:UIActivityIndicatorView?
    
    let requester = EventosRequester()
    var offset = 0
    var limit = 110
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UFV Eventos"
        
        //back button white color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.hidesBackButton = true
        
        
        let xib = UINib(nibName: "EventoCell", bundle: nil)
        self.tableView?.register(xib, forCellReuseIdentifier: "cell")
        
        self.progress?.isHidden = true
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(handleGesture))
        swipeRight.direction = .right
        self.view.addGestureRecognizer(swipeRight)
        
        navigationController?.navigationBar.barTintColor = UIColor(hexFromString: "890505")
        
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Menu",
            style: UIBarButtonItemStyle.plain,
            target: self,
            action: #selector(abrirMenu)
        )
        
        navigationItem.leftBarButtonItem?.tintColor = UIColor.white //opcao MENU branca na barra de navegacao
        
        requester.getEventos(offset: offset, limit: limit) { (ready, success) in
            if(ready) {
                self.progress?.stopAnimating()
                if (success) {
                    self.tableView?.reloadData()
                }
            }
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.progress?.startAnimating()
        
        print("Atualizei as categorias")
        
        if(UsuarioSingleton.shared.categoriasUpdate) {
            if ((UsuarioSingleton.shared.categoriasPref?.isEmpty)!) {
                requester.getEventos(offset: offset, limit: limit) { (ready, success) in
                    if(ready) {
                        self.progress?.stopAnimating()
                        if (success) {
                            self.tableView?.reloadData()
                        }
                    }
                }
            } else {
                requester.getEventosPorUsuario(idUsuario: (UsuarioSingleton.shared.usuario?.id)!,offset: offset, limit: limit) { (ready, success) in
                    if(ready) {
                        if (success) {
                            self.tableView?.reloadData()
                        }
                    }
                }
            }
            UsuarioSingleton.shared.categoriasUpdate = false
        }
        self.progress?.stopAnimating()
    }
    
    
    @objc func handleGesture(gesture: UISwipeGestureRecognizer) -> Void {
        if gesture.direction == UISwipeGestureRecognizerDirection.right {
            if let drawerController = parent as? KYDrawerController {
                drawerController.setDrawerState(.closed, animated: true)
            }
        }
    }
    
    @objc func abrirMenu(_ sender: UIBarButtonItem) {
        if let drawerController = navigationController?.parent as? KYDrawerController {
            drawerController.setDrawerState(.opened, animated: true)
        }
    }
    
    @IBAction func filtrarCategoria() {
        let filtrarCategoriasView = FiltrarCategoriasView()
        self.navigationController?.pushViewController(filtrarCategoriasView, animated: true)
    }
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let  height = scrollView.frame.size.height
//        let contentYoffset = scrollView.contentOffset.y
//        let distanceFromBottom = scrollView.contentSize.height - contentYoffset
//        //chegou ao fim da tabela
//        if distanceFromBottom < height {
//            limit += 10
//            if ((UsuarioSingleton.shared.categoriasPref?.isEmpty)!) {
//                requester.getEventos(offset: offset, limit: limit) { (ready, success) in
//                    if(ready) {
//                        self.progress?.stopAnimating()
//                        if (success) {
//                            self.tableView?.reloadData()
//                        }
//                    }
//                }
//            } else {
//                requester.getEventosPorUsuario(idUsuario: (UsuarioSingleton.shared.usuario?.id)!,offset: offset, limit: limit) { (ready, success) in
//                    if(ready) {
//                        if (success) {
//                            self.tableView?.reloadData()
//                        }
//                    }
//                }
//            }
//        }
//    }
}

extension PrincipalView: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EventosSingleton.shared.eventos.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView?.dequeueReusableCell(withIdentifier: "cell") as! EventoCell     // Cast da célula para EventoCell
        let linha = indexPath.row
        let evento = EventosSingleton.shared.eventos![linha]
        
        cell.tituloLb?.text = evento.denominacao
        let formato = DateFormatter()
        formato.dateFormat = "yyyy-MM-dd"
        
        let novoFormato = DateFormatter()
        novoFormato.dateFormat = "dd/MM"
        
        if(evento.datainicio != "2018-10-21") {
            let dataString:String = novoFormato.string(from: formato.date(from: evento.datainicio)!)
            cell.dataLb?.text = dataString
        } else  { cell.dataLb?.text = "21/10" }
        
        let horaInicio = formatarData(valor: evento.horainicio, formatoAtual: "HH:mm:ss", formatoNovo: "HH:mm")
        let horaFim = formatarData(valor: evento.horafim, formatoAtual: "HH:mm:ss", formatoNovo: "HH:mm")
        cell.horarioLb?.text = "Horário: \(horaInicio) - \(horaFim)"
        
        
        cell.imagem?.image = UIImage(named: "\(evento.denominacao[0].lowercased()).png")
        
        return cell
    }
    
}

extension PrincipalView: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let linha = indexPath.row
        let evento = EventosSingleton.shared.eventos![linha]
        
        let vc = DetalhesEventoView(nibName: "DetalhesEventoView", bundle: nil)
        vc.evento = evento
        self.navigationController!.pushViewController(vc, animated: false)
        
    }
    
}
