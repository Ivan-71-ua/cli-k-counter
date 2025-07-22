sub Main()
    screen = createObject("roSGScreen")
    port   = createObject("roMessagePort")
    screen.setMessagePort(port)

    scene  = screen.createScene("MainScene")
    screen.show() 
    ' vscode_rale_tracker_entry


    while true
        msg = wait(0, port)
        if type(msg) = "roSGScreenEvent" and msg.isScreenClosed()
            exit while
        end if
    end while
end sub
