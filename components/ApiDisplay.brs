sub init()
    m.top.setFocus(true)
    m.apiHitBtn = m.top.findNode("apiHitBtn")
    m.apiHitBtn.visible = false
    m.logoutBtn = m.top.findNode("logoutBtn")
    m.loggedUserName = m.top.findNode("loggedUserName")
    print "Before Fetching data"
    m.apiHitBtn.observeField("buttonSelected","onFetchingDataFromApi")
    m.logoutBtn.observeField("buttonSelected","onlogout")
    
    '----Row List-------
    m.rowListArray = m.dataArr
    m.apiDataList = m.top.findNode("listData")
    m.apiDataList.itemComponentName = "RowlistComponent"
    m.apiDataList.itemSize = [1920,300]
    m.apiDataList.rowHeights = 300
    m.apiDataList.rowItemSize = [300, 300]
    m.apiDataList.itemSpacing = [ 0, 80 ]
    m.apiDataList.rowItemSpacing = [ [20, 0] ]
    m.apiDataList.rowFocusAnimationStyle = "floatingFocus"
    m.apiDataList.rowLabelOffset = [ [0, 50] ]
    m.apiDataList.rowLabelColor="0xFFFF00ff"
    m.apiDataList.showRowLabel = true
    m.apiDataList.visible = true
    m.apiDataList.SetFocus(true)
    m.apiDataList.observeField("rowItemFocused","onRowItemFocused")
    m.apiDataList.observeField("rowItemSelected","onRowItemSelected")
    '------Row List---------
    
    m.musicVideo = m.top.findNode("musicVideo")   
    m.store = CreateObject("roRegistrySection", "UserApplication")
    if m.store.Exists("UserNameRegistry") 
        print "UserNameRegistry : ",m.store.Read("UserNameRegistry") 
        m.loggedUserName.text = m.store.Read("UserNameRegistry")
    else 
        m.loggedUserName.text = "Empty"
    end if
    
end sub

function onRowItemFocused()
    print "rowItemFocused : ", m.apiDataList.rowItemFocused   
End function

function onRowItemSelected()
    print "rowItemSelected : ", m.apiDataList.rowItemSelected
    setVideo()
End function

function showdialog()     
      progressdialog = createObject("roSGNode", "ProgressDialog")
      'm.progressdialog.backgroundUri = "pkg:/images/rsgde_dlg_bg_hd.9.png"
      progressdialog.title = "Example Progress Dialog"
      print "m.top.getScene().dialog---->",m.top.getScene()'.dialog
      m.top.getScene().dialog = progressdialog         
end function

function setVideo()
    m.videoContent = createObject("roSGNode","ContentNode")
    print "videoContent---->",m.videoContent
    m.videoContent.url = "https://roku.s.cpl.delvenetworks.com/media/59021fabe3b645968e382ac726cd6c7b/60b4a471ffb74809beb2f7d5a15b3193/roku_ep_111_segment_1_final-cc_mix_033015-a7ec8a288c4bcec001c118181c668de321108861.m3u8"
    m.videoContent.title = "Rhyme video"
    m.videoContent.streamformat = "hls"
    m.musicVideo.observeField("state","onCheckingVideoState")
    m.musicVideo.content = m.videoContent
    m.musicVideo.control = "play"
    m.musicVideo.visible = true
end function

function onCheckingVideoState()
    print m.musicVideo.state
end function

function onSetFocusOnButton()
    m.apiHitBtn.setFocus(true)
end function

function onStartApiLoading()
    m.taskCompObj = CreateObject("roSGNode", "TaskComponent")
    m.taskCompObj.observeField("content","onContentReceived")
    m.taskCompObj.control = "RUN"
    showdialog()
end function

'---------- Row List &&&&& Api Hit-------
function onFetchingDataFromApi() 
    print "Fetching data"  
        
end function
'---------- Row List &&&&& Api Hit-------

function onContentReceived()
    print "hello"
    print "m.taskCompObj.content ----> ",m.taskCompObj.content.content.count()
    m.dataArr = m.taskCompObj.content.content
    m.apiDataList.content = GetRowListContent()
    m.apiDataList.setFocus(true)  
    'print "m.dataArr  : ",m.dataArr
   'GetRowListContent()
    m.top.getScene().dialog.close = true   
     
End function

function GetRowListContent()
   parentContentNode = CreateObject("roSGNode", "ContentNode")
   print "This is row"
   'print "m.dataArr--->",m.dataArr
   'for item = 0 to m.dataArr.count()-1
        row = parentContentNode.CreateChild("ContentNode")
        row.title = "Rhymes"
        for index = 0 to m.dataArr.count()-1
        print "row.title--->",m.dataArr[index].title
            rowItem = row.CreateChild("RowListComponentData")
            rowItem.labelTitle = m.dataArr[index].title
        end for
   'end for  
   return parentContentNode
End function

function onlogout()
    m.store = CreateObject("roRegistrySection", "UserApplication")
    m.store.Delete("UserNameRegistry")
    m.store.Flush()
    m.store.Delete("UserPasswordRegistry")
    m.store.Flush()
    print "UserNameRegistry : ",m.store.Read("UserNameRegistry")
    print "UserPasswordRegistry : ",m.store.Read("UserPasswordRegistry")
    m.top.prevScreen.logoutValue = "logout"
    m.top.visible = false
end function

function onKeyEvent(key as String, press as Boolean) as Boolean
    if press
        
        if key = "right"
            if m.apiHitBtn.hasFocus()
                print "focus on logout btn"
                m.logoutBtn.setFocus(true)
            end if
            
        else if key = "left"
            if m.logoutBtn.hasFocus()
                print "focus on show data btn"
                m.apiHitBtn.setFocus(true)
            end if
            
        else if key = "up"
                m.logoutBtn.setFocus(true) 
        
        else if key = "down"
                m.apiDataList.SetFocus(true)       
            
        else if key = "back"
        print "on BACK key press video is stopped"
           m.musicVideo.control = "stop"
           m.musicVideo.visible = false
           return true
        end if 
    end if
end function



