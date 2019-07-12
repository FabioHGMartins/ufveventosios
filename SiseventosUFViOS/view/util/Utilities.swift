//
//  Utilities.swift
//  SiseventosUFViOS
//
//  Created by Fabio Martins on 22/10/18.
//  Copyright © 2018 Fabio Martins. All rights reserved.
//

import Foundation

import EventKit

func formatarData(valor: String, formatoAtual: String, formatoNovo:String) -> String{
    let atual = DateFormatter()
    atual.dateFormat = formatoAtual
    
    let novo = DateFormatter()
    novo.dateFormat = formatoNovo    
    
    let valorNovo:String = novo.string(from: atual.date(from: valor)!)
    return "\(valorNovo)"
}

func addEventToCalendar(title: String, description: String?, startDate: Date, endDate: Date, completion: ((_ success: Bool, _ error: NSError?) -> Void)? = nil) {
    let eventStore = EKEventStore()
    
    eventStore.requestAccess(to: .event, completion: { (granted, error) in
        if (granted) && (error == nil) {
            let event = EKEvent(eventStore: eventStore)
            event.title = title
            event.startDate = startDate
            event.endDate = endDate
            event.notes = description
            event.calendar = eventStore.defaultCalendarForNewEvents
            do {
                try eventStore.save(event, span: .thisEvent)
            } catch let e as NSError {
                completion?(false, e)
                return
            }
            completion?(true, nil)
        } else {
            completion?(false, error as NSError?)
        }
    })
}
