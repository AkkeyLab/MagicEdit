//
//  ViewController.swift
//  MagicEdit
//
//  Created by 板谷晃良 on 2015/11/29.
//  Copyright © 2015年 AkkeyLab. All rights reserved.
//

import UIKit
import CoreBluetooth
import AVFoundation

extension UIColor {
    convenience init(r: Int, g: Int, b: Int, a: Int = 255) {
        let red = CGFloat(Double(r & 0xFF) / 255.0)
        let green = CGFloat(Double(g & 0xFF) / 255.0)
        let blue = CGFloat(Double(b & 0xFF) / 255.0)
        let alpha = CGFloat(Double(a & 0xFF) / 255.0)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }
}

extension String {
    var count: Int {
        get { return self.characters.count }
    }
}

class ViewController: UIViewController, UITextViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
    
    //Value
    private var displaySize_width:    CGFloat!
    private var displaySize_height:   CGFloat!
    //Text
    //private var mainLabel:    UILabel!
    private var contentText:  UITextView!
    private var nowPointa:    [Int] = [0, 0]
    private var tmpPointa:    [Int] = [0, 0]
    
    //private var mainViewText: String!
    private var notesView:    String = ""
    
    //Define
    private let UUID_VSP: [CBUUID] = [CBUUID(string: "bd011f22-7d3c-0db6-e441-55873d44ef40")]
    private let UUID_TX:   CBUUID  =  CBUUID(string: "2a750d7d-bd9a-928f-b744-7d5a70cef1f9")
    private let UUID_RX:   CBUUID  =  CBUUID(string: "0503b819-c75b-ba9b-3641-6a7f338dd9bd")
    //BLE
    private var ble_CentralManager: CBCentralManager!
    private var ble_TargetPeripheral: CBPeripheral!
    private var ble_characteristic: CBCharacteristic!
    private var bleBool: Bool = false
    private var passIndicator: Bool = false
    private var ble_sw: Bool = true
    
    //Object
    private let indicator = ActivityIndicator()
    private let mode      = GameMode()
    private let buttonObj = ButtonController()
    private let talker = AVSpeechSynthesizer()
    
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if mode.getMode() == "new" {
            let selectAlert: UIAlertController = UIAlertController(title: "使用方法", message: "使用方法を選択してください", preferredStyle: .Alert)
            //MysticSD button push
            let mysticSDAction = UIAlertAction(title: "MysticSD", style: .Default) { action in
                //BLE START
                self.ble_CentralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
                //Indicator
                self.indicator.start(self)
                self.passIndicator = true
                //Mode
                self.mode.setMode("MysticSD")
            }
            //Manual button push
            let manualAction = UIAlertAction(title: "Manual", style: .Default){ action in
                //Mode
                self.mode.setMode("Manual")
            }
            //Alert add view
            selectAlert.addAction(mysticSDAction)
            selectAlert.addAction(manualAction)
            //Alert start
            presentViewController(selectAlert, animated: true, completion: nil)
        }else if mode.getMode() == "MysticSD" {
            //BLE START
            ble_CentralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
            //Indicator
            indicator.start(self)
            passIndicator = true
        }else{
            ble_sw = false
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        //Initialization++++++++++
        //self.view.backgroundColor = UIColor(r: 160, g: 216, b: 239)
        self.view.backgroundColor = UIColor.grayColor()
        
        displaySize_width  = self.view.frame.width
        displaySize_height = self.view.frame.height
        //++++++++++++++++++++++++
        
        let label = ColorLabel()
        label.makeLabel(self)
        
        buttonObj.setButtons(self)
        
        contentText = UITextView(frame: CGRectMake(0, 0, displaySize_width - 100, displaySize_height - 300))
        contentText.backgroundColor = UIColor(r: 255, g: 255, b: 255)
        contentText.text = notesView
        contentText.layer.masksToBounds = true
        contentText.layer.cornerRadius = 10.0
        contentText.layer.borderWidth = 1
        contentText.layer.borderColor = UIColor.whiteColor().CGColor
        contentText.font = UIFont.systemFontOfSize(CGFloat(15))
        contentText.textColor = UIColor.blackColor()
        contentText.textAlignment = NSTextAlignment.Left
        contentText.dataDetectorTypes = UIDataDetectorTypes.All
        contentText.layer.shadowOpacity = 0
        contentText.editable = true
        contentText.delegate = self
        contentText.alpha = 0.7
        contentText.layer.position = CGPoint(x: displaySize_width / 2, y: 325)
        self.view.addSubview(contentText)
        
        
        stringHighlight()
    }
    
    func onClickButton(sender: UIButton) {
        
        if sender == buttonObj.getButtonObject(4, x: 11) {
            // setting mode
            if bleBool {
                ble_TargetPeripheral.setNotifyValue(false, forCharacteristic: ble_characteristic) //cut notification
                ble_CentralManager.cancelPeripheralConnection(ble_TargetPeripheral) //cut ble
                buttonObj.getButtonObject(4, x: 11).backgroundColor = UIColor.blueColor()
                mode.setMode("Manual")
                
            }else if ble_sw {
                if(passIndicator){
                    indicator.activityIndicator.stopAnimating()
                    ble_CentralManager.stopScan()
                }
                mode.setMode("Manual")
                ble_sw = !ble_sw
            }else{
                //Indicator stop
                if(passIndicator){
                    indicator.activityIndicator.stopAnimating()
                }
                //BLE START
                ble_CentralManager = CBCentralManager(delegate: self, queue: nil, options: [CBCentralManagerOptionShowPowerAlertKey: true])
                //Indicator
                indicator.start(self)
                passIndicator = true
                mode.setMode("MysticSD")
                ble_sw = !ble_sw
            }
        }else{
            // touch input mode
            // color init **********
            for var y = 0; y < 5; y++ {
                for var x = 0; x < 12; x++ {
                    buttonObj.getButtonObject(y, x: x).backgroundColor = UIColor.whiteColor()
                    buttonObj.getButtonObject(y, x: x).setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
                    buttonObj.getButtonObject(y, x: x).alpha = 0.7
                }
            }
            if bleBool {
                buttonObj.getButtonObject(4, x: 11).backgroundColor = UIColor.redColor()
                buttonObj.getButtonObject(4, x: 11).setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }else{
                buttonObj.getButtonObject(4, x: 11).backgroundColor = UIColor.blueColor()
                buttonObj.getButtonObject(4, x: 11).setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
            }
            // *********************
            
            for var y = 0; y < 5; y++ {
                for var x = 0; x < 5; x++ {
                    if sender == buttonObj.getButtonObject(y, x: x) {
                        pointColor(y, x: x)
                        let data = buttonObj.getButtonText(y, x: x)
                        notesView += data
                        contentText.text = notesView
                        voiceOut(data)
                        
                        tmpPointa[0] = x
                        tmpPointa[1] = y
                    }
                }
            }
            for var y = 0; y < 5; y++ {
                for var x = 6; x < 11; x++ {
                    if sender == buttonObj.getButtonObject(y, x: x) {
                        pointColor(y, x: x)
                        let data = buttonObj.getButtonText(y, x: x)
                        notesView += data
                        contentText.text = notesView
                        voiceOut(data)
                        
                        tmpPointa[0] = x
                        tmpPointa[1] = y
                    }
                }
            }
            
            if sender == buttonObj.getButtonObject(0, x: 11) {
                pointColor(0, x: 11)
                let data = buttonObj.getButtonText(0, x: 11)
                notesView += data
                contentText.text = notesView
                voiceOut(data)
                
                tmpPointa[0] = 11
                tmpPointa[1] = 0
            }else if sender == buttonObj.getButtonObject(2, x: 5) {
                pointColor(2, x: 5)
                notesView += buttonObj.getButtonText(2, x: 5)
                contentText.text = notesView
                
                tmpPointa[0] = 5
                tmpPointa[1] = 2
            }else if sender == buttonObj.getButtonObject(3, x: 5) {
                pointColor(3, x: 5)
                notesView += buttonObj.getButtonText(3, x: 5)
                contentText.text = notesView
                
                tmpPointa[0] = 5
                tmpPointa[1] = 3
            }else if sender == buttonObj.getButtonObject(0, x: 5) {
                pointColor(0, x: 5)
                //dakuten
                let data = buttonObj.getDackText(tmpPointa[1], x: tmpPointa[0])
                chgText(data)
                voiceOut(data)
            }else if sender == buttonObj.getButtonObject(1, x: 5) {
                pointColor(1, x: 5)
                //handakuten
                let data = buttonObj.getHDakText(tmpPointa[1], x: tmpPointa[0])
                chgText(data)
                voiceOut(data)
            }else if sender == buttonObj.getButtonObject(4, x: 5) {
                pointColor(4, x: 5)
                //mini
                let data = buttonObj.getMiniText(tmpPointa[1], x: tmpPointa[0])
                chgText(data)
                voiceOut(data)
            }else if sender == buttonObj.getButtonObject(1, x: 11) {
                pointColor(1, x: 11)
                chgText("")
                voiceOut("戻る")
            }else if sender == buttonObj.getButtonObject(3, x: 11) {
                pointColor(3, x: 11)
                chgText("")
                voiceOut("戻る")
            }else if sender == buttonObj.getButtonObject(2, x: 11) {
                pointColor(2, x: 11)
                voiceOut(notesView)
            }
        }
    }
    
    func pointColor(y: Int, x: Int){
        buttonObj.getButtonObject(y, x: x).backgroundColor = UIColor(r: 255, g: 20, b: 147)
        buttonObj.getButtonObject(y, x: x).setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonObj.getButtonObject(y, x: x).alpha = 1.0
    }
    
    func stringHighlight(){
        buttonObj.getButtonObject(nowPointa[1], x: nowPointa[0]).backgroundColor = UIColor(r: 255, g: 20, b: 147)
        buttonObj.getButtonObject(nowPointa[1], x: nowPointa[0]).setTitleColor(UIColor.whiteColor(), forState: UIControlState.Normal)
        buttonObj.getButtonObject(nowPointa[1], x: nowPointa[0]).alpha = 1.0
    }
    
    func backHighlight(){
        buttonObj.getButtonObject(nowPointa[1], x: nowPointa[0]).backgroundColor = UIColor.whiteColor()
        buttonObj.getButtonObject(nowPointa[1], x: nowPointa[0]).setTitleColor(UIColor.blackColor(), forState: UIControlState.Normal)
        buttonObj.getButtonObject(nowPointa[1], x: nowPointa[0]).alpha = 0.7
    }
    
    func rightMove(){
        backHighlight()
        if nowPointa[0] == 11 {
            nowPointa[0] = 0
        }else{
            if nowPointa[0] == 10 && nowPointa[1] == 4 {
                nowPointa[0] = 0
            }else{
                nowPointa[0]++
            }
        }
        stringHighlight()
    }
    
    func leftMove(){
        backHighlight()
        if nowPointa[0] == 0 {
            if nowPointa[1] == 4 {
                nowPointa[0] = 10
            }else{
                nowPointa[0] = 11
            }
        }else{
            nowPointa[0]--
        }
        stringHighlight()
    }
    
    func upMove(){
        backHighlight()
        if nowPointa[1] == 0 {
            if nowPointa[0] == 11 {
                nowPointa[1] = 3
            }else{
                nowPointa[1] = 4
            }
        }else{
            nowPointa[1]--
        }
        stringHighlight()
    }
    
    func downMove(){
        backHighlight()
        if nowPointa[1] == 4 {
            nowPointa[1] = 0
        }else{
            if nowPointa[1] == 3 && nowPointa[0] == 11 {
                nowPointa[1] = 0
            }else{
                nowPointa[1]++
            }
        }
        stringHighlight()
    }
    
    //Decision
    func stringDecision(){
        if nowPointa[1] == 0 && nowPointa[0] == 5 {
            //dakuten
            let data = buttonObj.getDackText(tmpPointa[1], x: tmpPointa[0])
            chgText(data)
            voiceOut(data)
        }else if nowPointa[1] == 1 && nowPointa[0] == 5 {
            //handakuten
            let data = buttonObj.getHDakText(tmpPointa[1], x: tmpPointa[0])
            chgText(data)
            voiceOut(data)
        }else if nowPointa[1] == 4 && nowPointa[0] == 5 {
            //mini
            let data = buttonObj.getMiniText(tmpPointa[1], x: tmpPointa[0])
            chgText(data)
            voiceOut(data)
        }else if (nowPointa[1] == 1 || nowPointa[1] == 3) && nowPointa[0] == 11 {
            chgText("")
            voiceOut("戻る")
        }else if nowPointa[1] == 2 && nowPointa[0] == 11 {
            voiceOut(notesView)
        }else{
            //Normal
            let data = buttonObj.getButtonText(nowPointa[1], x: nowPointa[0])
            notesView += data
            contentText.text = notesView
            voiceOut(data)
            
            tmpPointa[0] = nowPointa[0]
            tmpPointa[1] = nowPointa[1]
        }
    }
    
    func chgText(inputS: String){
        if notesView.count <= 0 {
            notesView = ""
        }else{
            notesView = notesView.substringToIndex(notesView.startIndex.advancedBy(notesView.count - 1))
        }
        //NSLog("\(notesView.substringToIndex(notesView.startIndex.advancedBy(notesView.count - 1)))")
        notesView += inputS
        contentText.text = notesView
    }
    
    func voiceOut(out: String){
        let utterance = AVSpeechUtterance(string: out)
        utterance.voice = AVSpeechSynthesisVoice(language: "ja-JP")
        //utterance.pitchMultiplier = 1.2
        talker.speakUtterance(utterance)
    }
    
    //TextView
    func textViewDidChange(textView: UITextView) {
        print("textViewDidChange : \(textView.text)");
    }
    
    func textViewShouldBeginEditing(textView: UITextView) -> Bool {
        print("textViewShouldBeginEditing : \(textView.text)");
        return true
    }
    
    func textViewShouldEndEditing(textView: UITextView) -> Bool {
        print("textViewShouldEndEditing : \(textView.text)");
        return true
    }

    //BLE setting start. ++++++++++++++++++++++++++
    func centralManagerDidUpdateState(central: CBCentralManager) {
        switch(central.state){
        case .PoweredOff:
            break
        case .PoweredOn:
            //BLE Start
            ble_CentralManager.scanForPeripheralsWithServices(UUID_VSP, options: nil)
        case .Resetting:
            alert("Resetting",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unauthorized:
            alert("Unauthorized",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unknown:
            alert("Unknown",messageString: "開発担当までご連絡ください", buttonString: "OK")
        case .Unsupported:
            alert("Unsupported",messageString: "お使いの端末はBluetooth非対応です", buttonString: "OK")
        }
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral,
        advertisementData: [String: AnyObject], RSSI: NSNumber) {
            
            let name:NSString? = advertisementData["kCBAdvDataLocalName"] as? NSString
            
            if name == "BLESerial2" {
                //Indicator stop
                indicator.activityIndicator.stopAnimating()
                
                //Start connect
                self.ble_TargetPeripheral = peripheral
                ble_CentralManager.connectPeripheral(self.ble_TargetPeripheral, options: nil)
            }
    }
    
    //*** Swift 2 worning ***//
    //func centralManager(central: CBCentralManager, var didConnectPeripheral peripheral: CBPeripheral) {
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        //showNotification("MysticSDとの接続に成功しました！")//MapCoreViewController class
        ble_CentralManager.stopScan()
        
        bleBool = true
        buttonObj.getButtonObject(4, x: 11).backgroundColor = UIColor.redColor()
        
        //Find characteristics -> Go to "Find "Service" !"
        peripheral.delegate = self;
        peripheral.discoverServices(UUID_VSP)
        
    }
    
    func centralManager(central: CBCentralManager, didFailToConnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        //let notification = Notification()
        //notification.showNotification("MysticSDとの接続に失敗しました！")//MapCoreViewController class
        alert("Error",messageString: "MysticSDとの接続に失敗しました", buttonString: "OK")
        ble_CentralManager.stopScan()
    }
    
    //Find "Service" !
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        NSLog("Find service!")
        
        let services: NSArray = peripheral.services!
        
        for obj in services{
            if let service = obj as? CBService{
                //Find characteristics -> Go to "Find "Characteristics" !"
                peripheral.discoverCharacteristics(nil, forService: service)
                
            }
        }
    }
    
    //Find "Characteristics" !
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        NSLog("Find characteristics!")
        
        let characteristics: NSArray = service.characteristics!
        
        for obj in characteristics{
            if let characteristic = obj as? CBCharacteristic{
                //First write successful -> Go to "First write result"
                
                let value: [UInt8] = [2];
                let data: NSData = NSData(bytes: value, length: sizeof(Int))
                
                /*
                var value: CUnsignedChar = 0x01
                let data: NSData = NSData(bytes: &value, length: 1)
                */
                peripheral.writeValue(data, forCharacteristic: characteristic, type: CBCharacteristicWriteType.WithoutResponse)
                
                // move to "First write result"
                //peripheral.readValueForCharacteristic(characteristic) // Read only once
                peripheral.setNotifyValue(true, forCharacteristic: characteristic) // Notify
                ble_characteristic = characteristic
            }
        }
    }
    
    //When call notify start and end
    func peripheral(peripheral: CBPeripheral, didUpdateNotificationStateForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if error != nil{
            NSLog("Notify error")
        }else{
            NSLog("Notify success")
        }
    }
    
    //When call get data
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if characteristic.UUID.isEqual(UUID_TX){
            //NSLog("Read success!!")
            let data = characteristic.value
            let ptr = UnsafePointer<UInt8>(characteristic.value!.bytes)
            let bytes = UnsafeBufferPointer<UInt8>(start:ptr, count:data!.length)
            NSLog("Read value: \(bytes[0])")
            
            if bytes[0] == 1 {
                rightMove()
            }else
            if bytes[0] == 2 {
                leftMove()
            }else
            if bytes[0] == 3 {
                upMove()
            }else
            if bytes[0] == 4 {
                downMove()
            }else
            if bytes[0] == 5 {
                stringDecision()
            }
        }
    }
    
    //First write result
    func peripheral(peripheral: CBPeripheral!, didWriteValueForCharactertistic characteristic: CBCharacteristic!, error: NSError!){
        NSLog("First write result")
        //peripheral.readValueForCharacteristic(characteristic) // Read only once
        //peripheral.setNotifyValue(true, forCharacteristic: characteristic) // Notify
    }
    //BLE setting end. ++++++++++++++++++++++++++++
    
    func alert(titleString: String, messageString: String, buttonString: String){
        //Create UIAlertController
        let alert: UIAlertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .Alert)
        //Create action
        let action = UIAlertAction(title: buttonString, style: .Default) { action in
            NSLog("\(titleString):Push button!")
        }
        //Add action
        alert.addAction(action)
        //Start
        presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

