
sub init()
	m._counterScreen = m.top.findNode("counterScreen")
	if m._counterScreen <> invalid
		m._counterScreen.setFocus(true)
	end if
end sub
