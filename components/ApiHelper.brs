
    Function callApi(requestId as String, url as String,headers as Object,isPostApi as boolean,params as String,isPUTApi as boolean,isDELETEApi = false as boolean)    
    request = CreateObject("roUrlTransfer")
    port = CreateObject("roMessagePort")
    request.SetMessagePort(port)
    request.EnableEncodings(true)
    request.RetainBodyOnError(true)  
   

    print "URL is : ";url

    request.SetUrl(url)
    request.SetCertificatesFile("common:/certs/ca-bundle.crt")
    request.AddHeader("Content-type", "application/x-www-form-urlencoded")    
        
    If type(headers)="roAssociativeArray" Then
        For Each key in headers    
            request.AddHeader(UCase(key),headers[key])
        End For
    End If
    
    request.InitClientCertificates()       
    checkRokuConnection = CreateObject("roDeviceInfo")
    If(checkrokuconnection.GetLinkStatus()) Then
        if isPostApi = true or isPUTApi
            requestType = request.AsyncPostFromString(params)
        else
            print "GET"
            requestType = request.AsyncGetToString()
        end if    
        
        'add request into global object
        if(requestId=invalid or requestId="")            
            requestId=request.GetIdentity().ToStr()            
        end if
        If (requestType)
            while (true)
                msg = wait(10*1000, port)
                'print "response is " ; msg
                If (type(msg) = "roUrlEvent") then
                    code = msg.GetResponseCode() 
                    print "Response Code is: ";code
                    if (code = 200) then
                        return msg
                    else
                        customJson =  {"status":{"success":false,"error":code.toStr(),"message":msg.GetFailureReason()}}  
                        json = FormatJson(customJson,0)
                        return  json
                    end if
                Else  
                    customJson =  {"status":{"success":false,"error":"10202","message":"Execution Timeout","execution_time":"101.52292251587 ms"}}  
                    json = FormatJson(customJson,0)
                    return  json
                End If
            End while
        End If
     Else 
        return invalid
     End If     
  return invalid    
End Function