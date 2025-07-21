
sub init()
	m.top.duration = 2
	m.top.repeat   = true
	m.top.control  = "stop"

	
end sub


sub _onRunningChange(event as object)
	if m.top.running = true 
		m.top.control = "start"
	else
		m.top.control = "stop"
	end if
end sub


