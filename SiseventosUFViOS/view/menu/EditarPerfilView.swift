//
//  EditarPerfilView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 27/06/19.
//  Copyright © 2019 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController

class EditarPerfilView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {
    
    @IBOutlet var confirmarBt: UIButton?
    @IBOutlet var editarSenhaBt: UIButton?
    @IBOutlet var editarEmailBt: UIButton?
    
    @IBOutlet var nomeTf:UITextField?
    @IBOutlet var emailAtualTf:UITextField?
    @IBOutlet var emailNovoTf:UITextField?
    @IBOutlet var senhaAtualTf:UITextField?
    @IBOutlet var confirmarSenhaAtualTf:UITextField?
    @IBOutlet var senhaNovaTf:UITextField?
    @IBOutlet var confirmarSenhaNovaTf:UITextField?
    @IBOutlet var dataNascPicker:UIDatePicker?
    @IBOutlet var sexoPicker: UIPickerView?
    
    @IBOutlet var nomeTfErro:UITextView?
    @IBOutlet var emailAtualTfErro:UITextView?
    @IBOutlet var emailNovoTfErro:UITextView?
    @IBOutlet var senhaAtualTfErro:UITextView?
    @IBOutlet var confirmarSenhaAtualTfErro:UITextView?
    @IBOutlet var senhaNovaTfErro:UITextView?
    @IBOutlet var confirmarSenhaNovaTfErro:UITextView?
    
    @IBOutlet var switchDataNascimento:UISwitch?
    
    var pickerData: Array<String>!
    var sexoSelecionado : String!
    
    var requester: UsuarioRequester!
    
    @IBOutlet var progress:UIActivityIndicatorView?

    override func viewDidLoad() {super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Atualizar Perfil"
        
        //back button white color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.navigationItem.hidesBackButton = true
        
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
        
        self.sexoPicker?.delegate = self
        self.sexoPicker?.dataSource = self
        
        pickerData = ["Prefiro não dizer","Feminino","Masculino","Outro"]
        sexoSelecionado = UsuarioSingleton.shared.usuario!.sexo!
        
        //sexoSelecionado = pickerData[(sexoPicker?.selectedRow(inComponent: 0))!]
        
        print("\n\nviewDidLoad: ", sexoSelecionado, "\n\n")
        
        var menorData: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .year, value: -120, to: Date(), options: [])!
        }
        
        var maiorData: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .year, value: -5, to: Date(), options: [])!
        }
        
        let usuario = UsuarioSingleton.shared.usuario
        nomeTf?.text = usuario?.nome
        emailAtualTf?.text = usuario?.email
        
        dataNascPicker?.minimumDate = menorData
        dataNascPicker?.maximumDate = maiorData
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        print(usuario!.nascimento!, " ", usuario!.sexo!)
        
        //verifica data de nascimento padrão
        if usuario!.nascimento! == "1900-01-01" || usuario!.nascimento! == "1900-1-1" {
            switchDataNascimento?.isOn = false
            dataNascPicker?.isEnabled = false
        }else{
            let date = dateFormatter.date(from: (usuario?.nascimento)!)
            dataNascPicker?.date = date!
            print(date!)
        }
        
        //Seleciona o sexo correto no carregamento da tela
        sexoPicker?.selectRow(getPickerRow((usuario!.sexo)!), inComponent: 0, animated: false)
        
        requester = UsuarioRequester(self)
        
    }
    
    func getPickerRow(_ sexo: String) -> Int {
        print("\n\ngetPickerRow: ", sexo, "\n\n")
        
        if(sexo == "p") {
            return 0
        } else if(sexo == "f") {
            return 1
        } else if(sexo == "m") {
            return 2
        } else {
            return 3
        }
    }
    
    @IBAction func escolheOpcaoPorDataNascimento(){
        if switchDataNascimento?.isOn == true {
            print ("Switch ligado")
            dataNascPicker?.isEnabled = true
        }else{
            print ("Switch desligado")
            dataNascPicker?.isEnabled = false
        }
    }
    
    @IBAction func confirmar() {
        if(validaCampos()) {
            print(recuperaNasc())
            let usuarioAtual = (emailAtualTf?.text)!
            let senhaAtual = (senhaAtualTf?.text)!
            var usuarioNovo = usuarioAtual
            var senhaNova = senhaAtual
            if (emailNovoTf?.isEnabled)! {
                usuarioNovo = (emailNovoTf?.text)!
            }
            if (senhaNovaTf?.isEnabled)! {
                senhaNova = (senhaNovaTf?.text)!
            }
            
            var dt_nasc = ""
            
            //define data de nascimento padrão para quem não quiser informar
            if switchDataNascimento?.isOn == true {
                dt_nasc = recuperaNasc()
            }else{
                dt_nasc = "1900-1-1"
            }
            
            print("\n\nConfirmação: ", sexoSelecionado, "\n\n")
            
            let usuario = Usuario(id: (UsuarioSingleton.shared.usuario?.id)!,nome: (nomeTf?.text)!, email: usuarioNovo, senha: senhaNova, nascimento: dt_nasc, sexo: sexoSelecionado)
            self.progress!.startAnimating()
            let att = (editarEmailBt?.isSelected)! || (editarSenhaBt?.isSelected)!
            requester.atualizarUsuario(usuario: usuario, att: att, usuarioAtual: usuarioAtual, senhaAtual: senhaAtual) { (ready,success) in
                if(ready) {
                    if (success) {
                        if let drawerController = self.navigationController?.parent as? KYDrawerController {
                            let principalView = PrincipalView()
                            (drawerController.mainViewController as! UINavigationController).pushViewController(principalView, animated: true)
                            drawerController.setDrawerState(.closed, animated: true)
                        }
                    }
                }
                self.progress!.stopAnimating()
            }
        }else{
            Alerta.alerta("Edição incompleta", msg: "Favor preencher campos obrigatórios", view: self)
        }
    }
    
    @IBAction func habilitarNovoEmail() {
        editarEmailBt?.isSelected = !(editarEmailBt?.isSelected)!
        
        if(editarEmailBt?.isSelected == true) {
            emailNovoTf?.isEnabled = false
        } else {
            emailNovoTf?.isEnabled = true
        }
        
    }
    
    @IBAction func habilitarNovaSenha() {
        editarSenhaBt?.isSelected = !(editarSenhaBt?.isSelected)!
        
        if(editarSenhaBt?.isSelected == true) {
            senhaNovaTf?.isEnabled = false
            confirmarSenhaNovaTf?.isEnabled = false
        } else {
            senhaNovaTf?.isEnabled = true
            confirmarSenhaNovaTf?.isEnabled = true
        }
        
    }
    
    func recuperaNasc() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: dataNascPicker!.date)
        return dateString
    }
    
    
    func validaCampos() -> Bool {
        var l = true
        if (nomeTf?.text?.isEmpty)! {
            nomeTfErro?.isHidden = false
            l = false
        } else {
            nomeTfErro?.isHidden = true
        }
        if (emailAtualTf?.text?.isEmpty)! {
            emailAtualTfErro?.isHidden = false
            l = false
        } else {
            emailAtualTfErro?.isHidden = true
        }
        if (senhaAtualTf?.text?.isEmpty)! {
            senhaAtualTfErro?.isHidden = false
            l = false
        } else {
            senhaAtualTfErro?.isHidden = true
        }
        if (confirmarSenhaAtualTf?.text?.isEmpty)! {
            confirmarSenhaAtualTfErro?.isHidden = false
            l = false
        } else if (senhaAtualTf?.text != confirmarSenhaAtualTf?.text) {
            confirmarSenhaAtualTfErro?.text = "A confirmação não coincide com a senha atual"
            senhaAtualTf?.text = ""
            confirmarSenhaAtualTf?.text = ""
            confirmarSenhaAtualTfErro?.isHidden = false
            l = false
        } else {
            confirmarSenhaAtualTfErro?.isHidden = true
        }
        
        if ((emailNovoTf?.isEnabled)! && (emailNovoTf?.text?.isEmpty)!) {
            emailNovoTfErro?.isHidden = false
            l = false
        } else {
            emailNovoTfErro?.isHidden = true
        }
        
        if((senhaNovaTf?.isEnabled)! && (senhaNovaTf?.text?.isEmpty)!) {
            senhaNovaTfErro?.isHidden = false
            l = false
        } else {
            senhaNovaTfErro?.isHidden = true
        }
        
        if(confirmarSenhaNovaTf?.isEnabled)! {
            if (confirmarSenhaNovaTf?.text?.isEmpty)! {
                confirmarSenhaNovaTfErro?.isHidden = false
                l = false
            } else if (senhaNovaTf?.text != confirmarSenhaNovaTf?.text) {
                confirmarSenhaNovaTfErro?.text = "A confirmação não coincide com a nova senha"
                senhaNovaTf?.text = ""
                confirmarSenhaNovaTf?.text = ""
                confirmarSenhaNovaTfErro?.isHidden = false
                l = false
            } else {
                confirmarSenhaNovaTfErro?.isHidden = true
            }
        }
        
        return l
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == nomeTf) {
            emailAtualTf?.becomeFirstResponder()
            return true
        } else if(textField == emailAtualTf) {
            senhaAtualTf?.becomeFirstResponder()
            return true
        } else if(textField == senhaAtualTf) {
            confirmarSenhaAtualTf?.becomeFirstResponder()
            return true
        } else if(textField == confirmarSenhaAtualTf) {
            confirmarSenhaAtualTf?.resignFirstResponder()
            return true
        }
        return false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //chamado toda vez que uma opção de sexo é escolhida
        print("\n\npickerView: ", row, "\n\n")
        switch row {
            
        case 0:
            sexoSelecionado = "p"
            break
        case 1:
            sexoSelecionado = "f"
            break
        case 2:
            sexoSelecionado = "m"
            break
        default:
            sexoSelecionado = "o"
            break
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
}
