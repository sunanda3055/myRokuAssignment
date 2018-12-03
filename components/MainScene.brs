' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    m.userNameBtn = m.top.findNode("userNameBtn")
    m.userNameBtn.setFocus(true)
    m.userNameBtn.observeField("buttonSelected","onInputUserName")
    m.userPasswordBtn = m.top.findNode("userPasswordBtn")
    m.userPasswordBtn.observeField("buttonSelected","onInputuserPassword")
    m.loginBtn = m.top.findNode("loginBtn")
    m.loginBtn.observeField("buttonSelected","onUserLogin")
    m.userKeyboard = m.top.findNode("userKeyboard")
    m.userKeyboard.visible = false
    m.field = ""
    
    m.store = CreateObject("roRegistrySection", "UserApplication")
    if m.store.Exists("UserNameRegistry") and m.store.Exists("UserPasswordRegistry")
        
        print "Already Logged in"
        print "UserNameRegistry : ",m.store.Read("UserNameRegistry")
        print "UserPasswordRegistry : ",m.store.Read("UserPasswordRegistry")
        
        m.apiDisplayScene = m.top.createChild("ApiDisplay")
        m.apiDisplayScene.prevScreen = m.top
        m.apiDisplayScene.setFocusOnButton = true
        m.apiDisplayScene.startApiLoading = true
        m.apiDisplayScene.visible = true
        m.apiDisplayScene.setFocus(true)
    
    else if not (m.store.Exists("UserNameRegistry") and m.store.Exists("UserPasswordRegistry"))
        m.userNameBtn.text = "Enter User Name" 
        m.userPasswordBtn.text = "Enter User Password"
        
    end if    
End sub

function onInputUserName()
    print "Entering user name"
    m.field = "userName"
    m.userKeyboard.text = ""
    m.userKeyboard.visible = true
    m.userKeyboard.setFocus(true)
End function

function onInputuserPassword()
    print "Entering user password"
    m.field = "userPassword"
    m.userKeyboard.text = ""
    m.userKeyboard.visible = true
    m.userKeyboard.setFocus(true)
end function

function onUserLogin()       
    if not (m.store.Exists("UserNameRegistry") and m.store.Exists("UserPasswordRegistry"))
        print "Error in login"
        dialog = CreateObject("roSGNode","Dialog")  
        dialog.title = "Credentials"
        dialog.titleColor = "0xff0000"
        dialog.message = "Please fill the fields necessary before login"
        dialog.messageColor = "0xFFFF00"
        m.top.dialog = dialog
    else
        print "Logging in"
        m.apiDisplayScene = m.top.createChild("ApiDisplay")
        m.apiDisplayScene.visible = true
        m.apiDisplayScene.setFocus(true)
        m.apiDisplayScene.startApiLoading = true
        m.apiDisplayScene.setFocusOnButton = true
        m.apiDisplayScene.prevScreen = m.top 
    end if   
        
end function

function onLogoutUser()
    'if m.top.logoutValue = "logout"
        m.userNameBtn.setFocus(true)
        m.userNameBtn.text = "Enter User Name" 
        m.userPasswordBtn.text = "Enter User Password"
   ' end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "down"
            if m.userNameBtn.hasFocus()
                print "Focus on password btn"
                m.userPasswordBtn.setFocus(true)
            
            else if m.userPasswordBtn.hasFocus()
                print "Focus on login btn"
                m.loginBtn.setFocus(true)
            end if
        
        else if key = "up"
            if m.loginBtn.hasFocus()
                print "Focus on password btn"
                m.userPasswordBtn.setFocus(true)
            
            else if m.userPasswordBtn.hasFocus()
                print "Focus on userName btn"
                m.userNameBtn.setFocus(true)
            end if
            
        else if key = "play"
            if m.field = "userName"
            print "enter on play"
                m.userNameBtn.text = m.userKeyboard.text  
                m.store.Write("UserNameRegistry",m.userKeyboard.text)
                m.store.Flush()            
                m.userKeyboard.visible = false
                m.userNameBtn.setFocus(true)
            
            else if m.field = "userPassword"
            print "enter on play"
                m.userPasswordBtn.text = m.userKeyboard.text 
                m.store.Write("UserPasswordRegistry",m.userKeyboard.text)
                m.store.Flush()              
                m.userKeyboard.visible = false
                m.userPasswordBtn.setFocus(true)
            end if
            
        end if
            
    end if
end function





