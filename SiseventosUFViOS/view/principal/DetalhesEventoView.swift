//
//  DetalhesEventoView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 20/10/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import GoogleMaps
import MapKit
import CoreLocation


class DetalhesEventoView: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet fileprivate weak var mapView: GMSMapView!
    @IBOutlet var expandButton:UIButton!
    @IBOutlet var agendaButton:UIButton!
    @IBOutlet var scrollView:UIScrollView!
    @IBOutlet var eventTitleView:UIView!
    @IBOutlet var contentView:UIView!
    
    @IBOutlet var tituloEventoLb:UILabel!
    @IBOutlet var dataEventoLb:UILabel!
    @IBOutlet var horarioEventoLb:UILabel!
    @IBOutlet var localEventoLb:UILabel!
    @IBOutlet var taxaInscricaoEventoLb:UILabel!
    @IBOutlet var localInscricaoEventoLb:UILabel!
    @IBOutlet var localInscricaoEventoTitleLb:UILabel!
    @IBOutlet var participantesEventoLb:UILabel!
    @IBOutlet var participantesEventoTitleLb:UILabel!
    @IBOutlet var publicoAlvoEventoLb:UILabel!
    @IBOutlet var publicoAlvoEventoTitleLb:UILabel!
    @IBOutlet var categoriaEventoLb:UILabel!
    @IBOutlet var categoriaEventoTitleLb:UILabel!
    
    @IBOutlet var programacaoContentView:UIView!
    @IBOutlet var programacaoFixedLb:UIView!
    @IBOutlet var descricaoFixedLb:UILabel!
    @IBOutlet var descricaoEventoLb:UILabel!
    @IBOutlet var programacaoTableView:UITableView!
    
    
    var evento:Evento!
    var fechado = false
    let locationManager = CLLocationManager()
    var userLocation:CLLocationCoordinate2D?
    var markerUser = GMSMarker()
    
    var contUpdateLocation = 0 //teste para contar atualizacoes de localizacao
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        contUpdateLocation = 0 //zera o contador de localizacao
        print("Tela fechou")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Detalhes do evento"
        
        //back button white color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        let voltarBt = UIBarButtonItem()
        voltarBt.title = "Voltar"
        self.navigationController?.navigationItem.backBarButtonItem = voltarBt

        let xib = UINib(nibName: "ProgramacaoCell", bundle: nil)
        self.programacaoTableView.register(xib, forCellReuseIdentifier: "cell")
        
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            self.locationManager.delegate = self
            self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            self.locationManager.startUpdatingLocation()
            print("ServicesEnabled")
        }
        
        //ativa a visualizacao da localizacao
        mapView.isMyLocationEnabled = true
        
        scrollView.layoutIfNeeded()
        scrollView.isScrollEnabled = true
        scrollView.contentSize = CGSize(width: self.view.frame.width, height: scrollView.frame.size.height)
        showContent()
        loadInfoEvento()
    
        
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locValue: CLLocationCoordinate2D = manager.location?.coordinate else {
            return
        }
        userLocation = locValue
        
        //teste contador de atualizacao
        contUpdateLocation += 1
        print("Contador: ", contUpdateLocation)
        
        loadCamera()

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
            localEventoLb.removeFromSuperview()
        } else {
            var aux = ""
            for local in evento.locais {
                aux += " \(local.descricao),"
            }
            aux.removeFirst()
            aux.removeLast()
            localEventoLb.text = aux
        }
        
        if(evento.teminscricao == "0") {
            taxaInscricaoEventoLb.text = "Não é necessário realizar inscrição"
            localInscricaoEventoLb.removeFromSuperview()
            localInscricaoEventoTitleLb.removeFromSuperview()
        } else if (evento.teminscricao == "1")  {
            taxaInscricaoEventoLb.text = "Gratuito"
            localInscricaoEventoLb.text = evento.linklocalinscricao
        } else {
            taxaInscricaoEventoLb.text = "R$\(evento.valorinscricao)"
            localInscricaoEventoLb.text = evento.linklocalinscricao
        }
        
        if(evento.mostrarparticipantes == "0") {
            participantesEventoLb.text = evento.participantes
        }else {
            participantesEventoLb.removeFromSuperview()
            participantesEventoTitleLb.removeFromSuperview()
        }
        
        if(evento.publico != nil && evento.publico != "") {
            publicoAlvoEventoLb.text = evento.publico
        } else {
            publicoAlvoEventoLb.removeFromSuperview()
            publicoAlvoEventoTitleLb.removeFromSuperview()
        }
        
        if(evento.categorias.count > 0) {
            var aux = evento.categorias[0].nome
            for i in 1...evento.categorias.count {
                aux += ", \(evento.categorias[i].nome)"
            }
            categoriaEventoLb.text = aux
        } else {
            categoriaEventoLb.removeFromSuperview()
            categoriaEventoTitleLb.removeFromSuperview()
        }
        
        if(evento.descricao_evento != "" && evento.descricao_evento != nil) {
            descricaoEventoLb.text = evento.descricao_evento
        }
        else {
            descricaoEventoLb.removeFromSuperview()
            descricaoFixedLb.removeFromSuperview()
        }
        
        if(evento.programacoes.count == 0) {
            programacaoFixedLb.removeFromSuperview()
            programacaoTableView.removeFromSuperview()
        }
        
        if(descricaoEventoLb.isHidden && programacaoFixedLb.isHidden) {
            programacaoContentView.removeFromSuperview()
        }
        
    }
    
    @IBAction func showContent() {
        if(fechado) {
            expandButton.setBackgroundImage(UIImage(named: "reduce.png"), for: UIControlState.normal)
            contentView.isHidden = false
        } else {
            expandButton.setBackgroundImage(UIImage(named: "expand.png"), for: UIControlState.normal)
            contentView.isHidden = true
        }
        fechado = !fechado
    }
    
    @IBAction func agendarEvento() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = dateFormatter.date(from: (evento.datainicio + " " + evento.horainicio))
        let date2 = dateFormatter.date(from: (evento.datafim + " " + evento.horafim))
        
        var localizacao = ""
        if evento.locais.count != 0 {
            localizacao = evento.locais[0].descricao
        }
        
        addEventToCalendar(title: evento.denominacao, location: localizacao, description: evento.descricao_evento, startDate: date1!, endDate: date2!) { (success, error) in
            if success {
                Alerta.alerta("Evento agendado com sucesso!", msg: "", view: self)
            } else {
                Alerta.alerta("Ocorreu algo inesperado...", msg: "Por favor, tente novamente", view: self)
            }
        }
    }
    
    func loadCamera() {
        let path = GMSMutablePath()
        path.add(userLocation!)
        
        for local in evento.locais {
            let position = CLLocationCoordinate2DMake(Double(local.lat)!, Double(local.lng)!)
            path.add(position)
        }
        
        let mapBounds = GMSCoordinateBounds(path: path)
        let cameraUpdate = GMSCameraUpdate.fit(mapBounds)
        
        if contUpdateLocation <= 1{
            mapView.moveCamera(cameraUpdate)
        }else{
            print("Camera já esta posicionada")
        }
        
        for local in evento.locais {
            let marker = GMSMarker()
            let posicao = CLLocationCoordinate2D(latitude: Double(local.lat)!, longitude: Double(local.lng)!)
            marker.position = posicao
            marker.title = local.descricao
            marker.snippet = local.descricao
            marker.map = mapView
            
            self.fetchRoute(from: userLocation!, to: posicao)
        }
        
        let posicao = CLLocationCoordinate2D(latitude: Double((userLocation?.latitude)!), longitude: Double((userLocation?.longitude)!))
        markerUser.position = posicao
        markerUser.title = "Minha localização"
        markerUser.icon = GMSMarker.markerImage(with: UIColor.blue)
        markerUser.map = mapView
    }
    
    func fetchRoute(from source: CLLocationCoordinate2D, to destination: CLLocationCoordinate2D) {
        
        let session = URLSession.shared
        
        let url = URL(string: "https://maps.googleapis.com/maps/api/directions/json?origin=\(source.latitude),\(source.longitude)&destination=\(destination.latitude),\(destination.longitude)&sensor=false&mode=driving&key=AIzaSyC2vzuwOgPqc-bKKZZ_OykqsTYx6qRTTe8")!
        
        let task = session.dataTask(with: url, completionHandler: {
            (data, response, error) in
            
            guard error == nil else {
                print(error!.localizedDescription)
                return
            }
            
            guard let jsonResult = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: Any], let jsonResponse = jsonResult else {
                print("error in JSONSerialization")
                return
            }
            
            guard let routes = jsonResponse["routes"] as? [Any] else {
                return
            }
            
            //correcao de falha quando localização é muito longe do evento
            if routes.count != 0 {
                print("Desenhou a rota")
                
                guard let route = routes[0] as? [String: Any] else {
                    return
                }
                
                guard let overview_polyline = route["overview_polyline"] as? [String: Any] else {
                    return
                }
                
                guard let polyLineString = overview_polyline["points"] as? String else {
                    return
                }
                
                //Call this method to draw path on map
                self.drawPath(from: polyLineString)
            }else{
                print("impossível desenhar a rota")
            }
        })
        task.resume()
    }
    
    func drawPath(from polyStr: String){
        DispatchQueue.main.async {
            let path = GMSPath(fromEncodedPath: polyStr)
            let polyline = GMSPolyline.init(path: path)
            polyline.strokeWidth = 3.0
            polyline.map = self.mapView // Google MapView
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
        
        let horaInicioString = formatarData(valor: programacao.horainicioprog, formatoAtual: "HH:mm:ss", formatoNovo: "HH:mm")
        let horaFimString = formatarData(valor: programacao.horafimprog, formatoAtual: "HH:mm:ss", formatoNovo: "HH:mm")
        cell.horarioLb?.text = "\(horaInicioString) até \(horaFimString)"
        
        if(programacao.descricaoprog != "") {
            cell.descricaoLb?.text = programacao.descricaoprog
        }
        
        return cell
    }
    
    
}
