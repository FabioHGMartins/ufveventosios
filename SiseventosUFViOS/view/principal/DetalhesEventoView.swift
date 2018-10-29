//
//  DetalhesEventoView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 20/10/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import GoogleMaps

class DetalhesEventoView: UIViewController {
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet var expandButton:UIButton!
    
    @IBOutlet var contentView:UIView!
    @IBOutlet var tituloEventoLb:UILabel!
    @IBOutlet var dataEventoLb:UILabel!
    @IBOutlet var horarioEventoLb:UILabel!
    @IBOutlet var localEventoLb:UILabel!
    @IBOutlet var taxaInscricaoEventoLb:UILabel!
    @IBOutlet var localInscricaoEventoLb:UILabel!
    @IBOutlet var participantesEventoLb:UILabel!
    @IBOutlet var publicoAlvoEventoLb:UILabel!
    @IBOutlet var categoriaEventoLb:UILabel!
    
    @IBOutlet var programacaoContentView:UIView!
    @IBOutlet var programacaoFixedLb:UIView!
    @IBOutlet var descricaoEventoLb:UILabel!
    @IBOutlet var programacaoTableView:UITableView!
    
    
    var evento:Evento!
    var fechado = true

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detalhes do evento"

        let xib = UINib(nibName: "ProgramacaoCell", bundle: nil)
        self.programacaoTableView.register(xib, forCellReuseIdentifier: "cell")
        
        loadCamera()
        loadInfoEvento()
        contentView.isHidden = true
    }
    
    func loadInfoEvento() {
        tituloEventoLb.text = evento.denominacao
        
        if (evento.datainicio != "" && evento.datafim != "") {
            let dataInicioString = formatarData(valor: evento.datainicio, formatoAtual: "yyyy-MM-dd", formatoNovo: "dd/MM/yyyy")
            let dataFimString = formatarData(valor: evento.datafim, formatoAtual: "yyyy-MM-dd", formatoNovo: "dd/MM/yyyy")
            dataEventoLb.text = "\(dataInicioString) até \(dataFimString)"
        } else {
            dataEventoLb.isHidden = true
        }
        
        if (evento.horainicio != "" && evento.horafim != "") {
            let horaInicio = formatarData(valor: evento.horainicio, formatoAtual: "HH:mm:ss", formatoNovo: "HH:mm")
            let horaFim = formatarData(valor: evento.horafim, formatoAtual: "HH:mm:ss", formatoNovo: "HH:mm")
            horarioEventoLb.text = "\(horaInicio) até \(horaFim)"
        } else {
            horarioEventoLb.isHidden = true
        }
        
        if(evento.locais.isEmpty) {
            localEventoLb.isHidden=true
        } else {
            var aux = evento.locais[0].descricao
            for local in evento.locais {
                aux += "\(local.descricao),"
            }
            aux.removeLast()
            localEventoLb.text = aux
        }
        
        if(evento.teminscricao == "0") {
            taxaInscricaoEventoLb.text = "Não é necessário realizar inscrição"
        } else if (evento.teminscricao == "1")  {
            taxaInscricaoEventoLb.text = "Gratuito"
            localInscricaoEventoLb.text = evento.linklocalinscricao
            localInscricaoEventoLb.isHidden = false
        } else {
            taxaInscricaoEventoLb.text = "R$\(evento.valorinscricao)"
        }
        
        if(evento.mostrarparticipantes == "1") {
            participantesEventoLb.text = evento.participantes
            participantesEventoLb.isHidden = false
        }
        
        if(evento.publico != nil && evento.publico != "") {
            publicoAlvoEventoLb.text = evento.publico
            publicoAlvoEventoLb.isHidden = false
        }
        
        if(evento.categorias.count > 0) {
            var aux = evento.categorias[0].nome
            for i in 1...evento.categorias.count {
                aux += ", \(evento.categorias[i].nome)"
            }
            categoriaEventoLb.text = aux
        }
        
        if(evento.descricao_evento != "" && evento.descricao_evento != nil) {
            descricaoEventoLb.text = evento.descricao_evento
        }
        else {
            descricaoEventoLb.isHidden = true
        }
        
        if(evento.programacoes.count == 0) {
            programacaoFixedLb.isHidden = true
            programacaoTableView.isHidden = true
        }
        
        if(descricaoEventoLb.isHidden && programacaoFixedLb.isHidden) {
            programacaoContentView.isHidden = true
        }
        
    }
    
    @IBAction func showContent() {
        if(fechado) {
            expandButton.setImage(UIImage(contentsOfFile: "reduce.png"), for: UIControlState.normal)
            contentView.isHidden = false
        } else {
            expandButton.setImage(UIImage(contentsOfFile: "expand.png"), for: UIControlState.normal)
            contentView.isHidden = true
        }
        fechado = !fechado
    }
    
    func loadCamera() {
        let path = GMSMutablePath()
        
        for local in evento.locais {
            let position = CLLocationCoordinate2DMake(Double(local.lat)!, Double(local.lng)!)
            path.add(position)
        }
        
        let mapBounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
        mapView.moveCamera(cameraUpdate)
        
        
        for local in evento.locais {
            let marker = GMSMarker()
            let posicao = CLLocationCoordinate2D(latitude: Double(local.lat)!, longitude: Double(local.lng)!)
            marker.position = posicao
            marker.title = local.descricao
            marker.snippet = local.descricao
            marker.map = mapView
        }
    }

}

extension DetalhesEventoView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return evento.programacoes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.programacaoTableView.dequeueReusableCell(withIdentifier: "cell") as! ProgramacaoCell
        let linha = indexPath.row
        let programacao = evento.programacoes[linha]
        
        let dataInicioString = formatarData(valor: programacao.datainicioprog, formatoAtual: "yyyy-MM-dd", formatoNovo: "dd/MM/yyyy")
        let dataFimString = formatarData(valor: programacao.datafimprog, formatoAtual: "yyyy-MM-dd", formatoNovo: "dd/MM/yyyy")
        cell.dataLb?.text = "\(dataInicioString) até \(dataFimString)"
        
        let horaInicioString = formatarData(valor: programacao.horainicioprog, formatoAtual: "yyyy-MM-dd", formatoNovo: "dd/MM/yyyy")
        let horaFimString = formatarData(valor: programacao.horafimprog, formatoAtual: "yyyy-MM-dd", formatoNovo: "dd/MM/yyyy")
        cell.horarioLb?.text = "\(horaInicioString) até \(horaFimString)"
        
        if(programacao.descricaoprog != "") {
            cell.descricaoLb?.text = programacao.descricaoprog
        }
        
        return cell
    }
    
    
}
