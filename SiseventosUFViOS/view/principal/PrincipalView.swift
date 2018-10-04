//
//  PrincipalView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 21/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController

class PrincipalView: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet var filtrarBt:UIButton?
    @IBOutlet var tableView:UITableView?

    @IBOutlet var progress:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "UFV Eventos"
        
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
        
        
        let requester = EventosRequester()
        self.progress?.isHidden = false
        self.progress?.startAnimating()
        
        let offset = 0
        let limit = 110
        requester.getEventos(offset: offset, limit: limit) { (ready, success) in
            if(ready) {
                self.progress?.stopAnimating()
                self.progress!.isHidden = true
                if (success) {
                    print(EventosSingleton.shared.eventos!)
                    self.tableView?.reloadData()
                }
            }
        }
        
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
        
        
        formato.dateFormat = "HH:mm:ss"
        novoFormato.dateFormat = "HH:mm"
        
        let horaInicio = novoFormato.string(from: formato.date(from: evento.horainicio)!)
        let horaFim = novoFormato.string(from: formato.date(from: evento.horafim)!)
        cell.horarioLb?.text = "Horário: \(horaInicio) - \(horaFim)"
        
        
        cell.imagem?.image = UIImage(named: "\(evento.denominacao[0].lowercased()).png")
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let linha = indexPath.row
        let evento = EventosSingleton.shared.eventos![linha]
        
//        let vc = DetalhesCarroViewController(nibName: "DetalhesCarroViewController", bundle: nil)
//        vc.carro = carro
//        self.navigationController!.pushViewController(vc, animated: false)
        
    }

}
