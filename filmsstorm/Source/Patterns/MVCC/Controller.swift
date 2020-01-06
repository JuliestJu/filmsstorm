//
//  Controller.swift
//  filmsstorm
//
//  Created by Юлия Воротченко on 06.01.2020.
//  Copyright © 2020 Alexander Andriushchenko. All rights reserved.
//

import UIKit

/**
 You must implement this proptocol on each UIViewController which is used in coordinators.
 In this MVC+C pattern  every controller must init with its own events.
 
 Controller`s  roles:
 - define reusable view to display data;
 - generate events for coordinator about user`s action;
 - RootViewGettable to get  access to controller`s view;
 - ControllerEventSourse to provide events for coordinator.
 
 Controller CAN NOT:
 - Show other controllers;
 - Know how to present itself;
 - Modify any data before presentation.
 */
protocol Controller: RootViewGettable, ControllerEventSourse {
    init(events: Event)
}

/// You must use this protocol to handle Controller's events in Coordinator (or use delegation as simple alternative).
protocol ControllerEventSourse {
    associatedtype Event: EventProtocol
    var events: ((Event) -> Void)? { get }
}

/// We need this protocol to subsc
protocol EventProtocol {}