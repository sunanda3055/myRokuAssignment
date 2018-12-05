' ********** Copyright 2016 Roku Corp.  All Rights Reserved. **********  

sub init()
    m.top.SetFocus(true)
    m.userNameBtn = m.top.findNode("userNameBtn")
    m.userNameBtnLabel = m.top.findNode("userNameBtnLabel")
    m.userNameBtn.setFocus(true)
    m.userNameBtnLabel.color = "0xff0000"
    m.userNameBtn.observeField("buttonSelected","onInputUserName")
    m.userPasswordBtn = m.top.findNode("userPasswordBtn")
    m.userPasswordBtnLabel = m.top.findNode("userPasswordBtnLabel")
    m.userPasswordBtn.observeField("buttonSelected","onInputuserPassword")
    m.loginBtn = m.top.findNode("loginBtn")
    m.loginBtnLabel = m.top.findNode("loginBtnLabel")
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
        m.userNameBtnLabel.text = "Enter User Email" 
        m.userPasswordBtnLabel.text = "Enter User Password"    
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
    m.userKeyboard.textEditBox.secureMode = true
end function

function onUserLogin()       
    if m.userNameBtnLabel.text.len() <>0 and isEmailValid(m.userNameBtnLabel.text) and m.userPasswordBtnLabel.text.len() <>0 'not (m.store.Exists("UserNameRegistry") and m.store.Exists("UserPasswordRegistry"))
        print "Error in login"
         print "Logging in"
        m.apiDisplayScene = m.top.createChild("ApiDisplay")
        m.apiDisplayScene.visible = true
        m.apiDisplayScene.setFocus(true)
        m.apiDisplayScene.startApiLoading = true
        m.apiDisplayScene.setFocusOnButton = true
        m.apiDisplayScene.prevScreen = m.top 
    else
        dialog = CreateObject("roSGNode","Dialog")  
        dialog.title = "Credentials"
        dialog.titleColor = "0xff0000"
        dialog.message = "Please fill the fields necessary before login"
        dialog.messageColor = "0xFFFF00"
        m.top.dialog = dialog
    end if   
        
end function

function onLogoutUser()
    'if m.top.logoutValue = "logout"
        m.userNameBtn.setFocus(true)
        m.userNameBtnLabel.text = "Enter User Email" 
        m.userPasswordBtnLabel.text = "Enter User Password"
        m.loginBtnLabel.color = "0xFFFF00"
   ' end if
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        if key = "down"
            if m.userNameBtn.hasFocus()
                print "Focus on password btn"
                m.userPasswordBtn.setFocus(true)
                m.userPasswordBtnLabel.color = "0xff0000"
                m.userNameBtnLabel.color = "0xFFFF00"
                
            else if m.userPasswordBtn.hasFocus()
                print "Focus on login btn"
                m.loginBtn.setFocus(true)
                m.loginBtnLabel.color = "0xff0000"
                m.userPasswordBtnLabel.color = "0xFFFF00"
            end if
        
        else if key = "up"
            if m.loginBtn.hasFocus()
                print "Focus on password btn"
                m.userPasswordBtn.setFocus(true)
                m.userPasswordBtnLabel.color = "0xff0000"
                m.loginBtnLabel.color = "0xFFFF00"
            
            else if m.userPasswordBtn.hasFocus()
                print "Focus on userName btn"
                m.userNameBtn.setFocus(true)
                m.userNameBtnLabel.color = "0xff0000"
                m.userPasswordBtnLabel.color = "0xFFFF00"
            end if
            
        else if key = "play"
            if m.field = "userName"
            print "enter on play"
                m.userNameBtnLabel.text = m.userKeyboard.text  
                
               ' r = CreateObject("roRegex", "^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$","")
                'print "Matching result--->",r.IsMatch(m.userKeyboard.text)
                if isEmailValid(m.userKeyboard.text)
                    print "Email is correct"
                else
                    print "Please enter correct email"
                    dialog = CreateObject("roSGNode","Dialog")  
                    dialog.title = "Enter Valid email"
                    dialog.titleColor = "0xff0000"
                    dialog.message = "Please enter email in correct format e.g. abc@mail.com"
                    dialog.messageColor = "0xFFFF00"
                    m.top.dialog = dialog
                    'dialog.observeField(fieldName,functionName)
                end if
                               
                m.store.Write("UserNameRegistry",m.userKeyboard.text)
                m.store.Flush()            
                m.userKeyboard.visible = false
                m.userNameBtn.setFocus(true)
            
            else if m.field = "userPassword"
            print "enter on play"
            
                print "m.userKeyboard.text.Len()----->",m.userKeyboard.text.Len()
                
                l = m.userKeyboard.text.Len() -1 
                starredText = ""
                m.x=box("")
                
                For i=0 To l Step +1
                    starredText = starredText + "*"
                    m.x.AppendString("*",1)
                End For
                
                print "m.x outer------->",m.x
                print "starredText----->",starredText
                                
                m.userPasswordBtnLabel.text = m.x 
                m.store.Write("UserPasswordRegistry",m.userKeyboard.text)
                m.store.Flush()              
                m.userKeyboard.visible = false
                m.userPasswordBtn.setFocus(true)
            end if
                  
        else if key = "back"
            m.userKeyboard.visible = false
            m.userNameBtn.setFocus(true)
        end if
            
    end if
    return true
end function


function isEmailValid(text as String) as Boolean
     r = CreateObject("roRegex", "^\w+@[a-zA-Z_]+?\.[a-zA-Z]{2,3}$","")
     return r.IsMatch(text)
end function




