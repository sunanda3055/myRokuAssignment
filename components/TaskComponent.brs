sub init()
print m.top
    m.top.functionName = "getData"
End sub

function getData()
    url = "https://api.cloud.altbalaji.com/zuul/catalogue/balaji/catalogue/filters/kids-home"
    response = callApi("", url, invalid, false, "", false)  
    print "response is : ",type (response) 
    if response <> invalid
        print "parse json : ",ParseJson(response)
        m.top.content = ParseJson(response)
    end if
End function