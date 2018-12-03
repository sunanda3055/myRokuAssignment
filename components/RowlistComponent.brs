sub init()
    print "INSIDE COMPONENT"
    m.top.setFocus(true)
    m.label1 = m.top.findNode("label1")         
End sub

sub onItemContentChanged()
    print "CONTENT"; m.top.itemContent.labelTitle
    m.label1.text = m.top.itemContent.labelTitle
End sub


