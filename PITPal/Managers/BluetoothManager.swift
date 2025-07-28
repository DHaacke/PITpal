//
//  BluetoothManager.swift
//  PITPal
//
//  Created by Doug Haacke on 6/16/25.
//

import SwiftUI
import CoreBluetooth

struct DiscoveredDevice: Identifiable {
    let id: UUID
    let name: String
    let services: [CBUUID]
}



@Observable
class BluetoothManager: NSObject, ObservableObject, CBCentralManagerDelegate, CBPeripheralDelegate {
   
    private var discoveredDevices: [DiscoveredDevice] = []
    private var centralManager: CBCentralManager!
    private var peripherals: [CBPeripheral] = []
    
    var connectedPeripheral: CBPeripheral?

    
    var pitTagNumber: String = ""
    var isScanning: Bool = false
    var connectionStatus: Int = K.SCANNING
    var isConnected: Bool = false
    
    
//    private var servicesUUID         = [CBUUID(string: "AF30")]  // MedPet $29 scanner
//    private var characteristicsUUID  =  CBUUID(string: "AE02")
    
     // * includes stratux
//     private var servicesUUID =       [CBUUID(string: "AF30"), CBUUID(string: "180A"), CBUUID(string: "180F"), CBUUID(string: "6E400001-B5A3-F393-E0A9-E50E24DCCA9E"), ]
//     private var characteristicsUUID = CBUUID(string: "FFE1") // and CBUUID(string: "AE02")
    
    private var servicesUUID         = [CBUUID(string: "AF30")]
    private var characteristicsUUID  =  CBUUID(string: "AE02")
    
   
    override init() {
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: .main)
        // enableBackgroundMode()
    }
    
    // MARK: - CBCentralManagerDelegate
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
            case .poweredOn:
                // Start scanning for peripherals
                central.scanForPeripherals(withServices: servicesUUID, options: nil)
                self.isScanning = true
                connectionStatus = K.SCANNING
            case .poweredOff:
                connectionStatus = K.BLUETOOTH_OFF
            case .unauthorized:
                connectionStatus = K.BLUETOOTH_UNAUTHORIZED
            default:
                break
        }
    }
   
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String: Any], rssi RSSI: NSNumber) {
        print("Discovered \(peripheral.name ?? "Unknown") at \(RSSI)")
        if !peripherals.contains(where: { $0.identifier == peripheral.identifier }) {
            peripherals.append(peripheral)
            peripheral.delegate = self
            centralManager.connect(peripheral, options: nil)
            connectionStatus = K.CONNECTING
            connectedPeripheral = peripheral
        }
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        // print("Connected to \(peripheral.name ?? "Unknown")")
        connectionStatus = K.CONNECTED
        isConnected = true
        peripheral.discoverServices(nil) // Discover all services
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        print("Discovered services for \(peripheral.name ?? "Unknown")")
        guard let services = peripheral.services else { return }
        let serviceUUIDs = services.map { $0.uuid }
        let deviceName = peripheral.name ?? "Unknown Device"
        
        for service in services {
            peripheral.discoverCharacteristics(nil, for: service)
        }
        
        DispatchQueue.main.async {
            if let existingIndex = self.discoveredDevices.firstIndex(where: { $0.id == peripheral.identifier }) {
                self.discoveredDevices[existingIndex] = DiscoveredDevice(id: peripheral.identifier, name: deviceName, services: serviceUUIDs)
            } else {
                self.discoveredDevices.append(DiscoveredDevice(id: peripheral.identifier, name: deviceName, services: serviceUUIDs))
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        print("Discovered characteristics for service \(service.uuid) on \(peripheral.name ?? "Unknown")")
        guard error == nil else { return }
        for characteristic in service.characteristics ?? [] {
            if characteristic.properties.contains(.read) {
                peripheral.readValue(for: characteristic)
                print("  Contains .read characteristic: \(characteristic.uuid)")
            }
            if characteristic.properties.contains(.notify) {
                peripheral.setNotifyValue(true, for: characteristic)
                print("  Contains .notify characteristic: \(characteristic.uuid)")
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        guard let value = characteristic.value, characteristic.uuid == characteristicsUUID else { return }
        // Convert received data to string
        if let text = String(data: value, encoding: .utf8) {
            DispatchQueue.main.async {
                self.pitTagNumber = text
                print("\(peripheral.name ?? "Unknown"): Updated value for characteristic \(characteristic.uuid): \(text)")
            }
        }
    }

    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        connectionStatus = K.CONNECTION_FAILED
        isConnected = false
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        peripherals.removeAll()
        discoveredDevices.removeAll()
        connectionStatus = K.DISCONNECTED
        isConnected = false
    }
    
    func restart() {
        centralManager.stopScan()
        self.isScanning = false
        self.discoveredDevices.removeAll()
        self.peripherals.removeAll()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
//            self.centralManager = CBCentralManager(delegate: self, queue: nil)
//        }
    }
    
    func enableBackgroundMode() {
        // Enable background mode for Bluetooth
        UIApplication.shared.beginBackgroundTask {
            // Code to handle background task
        }
    }
    
    
    
}
