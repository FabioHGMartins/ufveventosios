//
//  CadastrarUsuarioView.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 07/09/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import UIKit
import KYDrawerController

class CadastrarUsuarioView: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, UITextFieldDelegate {

    @IBOutlet var loginBt:UIButton?
    @IBOutlet var voltarBt:UIBarButtonItem?
    @IBOutlet var cadastrarBt: UIButton?
    
    @IBOutlet var nomeTf:UITextField?
    @IBOutlet var emailTf:UITextField?
    @IBOutlet var senhaTf:UITextField?
    @IBOutlet var confirmarSenhaTf:UITextField?
    @IBOutlet var dataNascPicker:UIDatePicker?
    @IBOutlet var sexoPicker: UIPickerView?
    
    @IBOutlet var nomeTfErro:UITextView?
    @IBOutlet var emailTfErro:UITextView?
    @IBOutlet var senhaTfErro:UITextView?
    @IBOutlet var confirmarSenhaTfErro:UITextView?

    var pickerData: Array<String>!
    var sexoSelecionado : String!
    
    var requester: UsuarioRequester!
    
    @IBOutlet var progress:UIActivityIndicatorView?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
        self.title = "Cadastrar"
        
        //back button white color
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
        self.sexoPicker?.delegate = self
        self.sexoPicker?.dataSource = self
        
        pickerData = ["Prefiro não dizer","Feminino","Masculino","Outro"]
        sexoSelecionado = pickerData[(sexoPicker?.selectedRow(inComponent: 0))!]
        
        var menorData: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .year, value: -120, to: Date(), options: [])!
        }
        
        var maiorData: Date {
            return (Calendar.current as NSCalendar).date(byAdding: .year, value: -5, to: Date(), options: [])!
        }
        
        dataNascPicker?.minimumDate = menorData
        dataNascPicker?.maximumDate = maiorData
        
        requester = UsuarioRequester(self)
        
    }
    
    @IBAction func login() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func cadastrar() {
        if(validaCampos()) {
            let usuario = Usuario(nome: (nomeTf?.text)!, email: (emailTf?.text)!, senha: (senhaTf?.text)!, nascimento: recuperaNasc(), sexo: sexoSelecionado)
            self.progress!.startAnimating()
            requester.cadastrarUsuario(usuario: usuario) { (ready,success) in
                if(ready) {
                    if (success) {
                        let principalView = PrincipalView(nibName:"PrincipalView", bundle: nil)
                        let menuView = MenuView(nibName:"MenuView", bundle: nil)
                        let drawerKYController     = KYDrawerController(drawerDirection: .left, drawerWidth: 240)
                        drawerKYController.mainViewController = UINavigationController(
                            rootViewController: principalView
                        )
                        drawerKYController.drawerViewController = menuView                        
                        self.present(drawerKYController, animated: true, completion: nil)
                    }
                }
                self.progress!.stopAnimating()
            }
        }else{
            Alerta.alerta("Cadastro incompleto", msg: "Favor preencher campos obrigatórios", view: self)
        }
    }
    
    func recuperaNasc() -> String {
        let dateFormatter = DateFormatter()
        
        //este é o padrão estabelecido pela API
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let dateString = dateFormatter.string(from: dataNascPicker!.date)
        print(dateString)
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
        if (emailTf?.text?.isEmpty)! {
            emailTfErro?.isHidden = false
            l = false
        } else {
            emailTfErro?.isHidden = true
        }
        if (senhaTf?.text?.isEmpty)! {
            senhaTfErro?.isHidden = false
            l = false
        } else {
            senhaTfErro?.isHidden = true
        }
        if (confirmarSenhaTf?.text?.isEmpty)! {
            confirmarSenhaTfErro?.isHidden = false
            l = false
        } else if (senhaTf?.text != confirmarSenhaTf?.text) {
            confirmarSenhaTfErro?.text = "A confirmação não coincide com a senha"
            senhaTf?.text = ""
            confirmarSenhaTf?.text = ""
            confirmarSenhaTfErro?.isHidden = false
            l = false
        } else {
            confirmarSenhaTfErro?.isHidden = true
        }
        
        return l
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if(textField == nomeTf) {
            emailTf?.becomeFirstResponder()
            return true
        } else if(textField == emailTf) {
            senhaTf?.becomeFirstResponder()
            return true
        } else if(textField == senhaTf) {
            confirmarSenhaTf?.becomeFirstResponder()
            return true
        } else if(textField == confirmarSenhaTf) {
            confirmarSenhaTf?.resignFirstResponder()
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
}
