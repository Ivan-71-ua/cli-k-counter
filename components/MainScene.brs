
sub init()
	m.counterLabel = m.top.findNode("counterLabel")
	m.incBtn = m.top.findNode("incBtn")
	m.decBtn = m.top.findNode("decBtn")
	m.resetBtn = m.top.findNode("resetBtn")
	m.btnRow = m.top.findNode("btnRow")			

	m.incBtn.observeField("buttonSelected", "onIncrement")
	m.decBtn.observeField("buttonSelected", "onDecrement")
	m.resetBtn.observeField("buttonSelected", "onReset")


	m.dynamicResetBtn = createObject("roSGNode", "Button")
	m.dynamicResetBtn.text = "Reset [dm]"
	m.dynamicResetBtn.visible  = false
	m.dynamicResetBtn.observeField("buttonSelected", "onReset")

   m.btnRow.appendChild(m.dynamicResetBtn)

	m.buttons = []                                 
	childCnt = m.btnRow.getChildCount()

	for i = 0 to childCnt - 1
		m.buttons.push( m.btnRow.getChild(i) )
	end for


	m.focusIndex = -1
	m.counter = 0
	m.top.setFocus(true)
	updateUI()
end sub


sub onIncrement()
	m.counter += 1
	updateUI()
end sub

sub onDecrement()
	if m.counter > 0 then
		m.counter -= 1
		updateUI()
	end if
end sub

sub onReset()
	m.counter = 0
	updateUI()
end sub


function onKeyEvent(key as String, press as Boolean) as Boolean
	if not press then return false         

	if key <> "left" and key <> "right" then return false

	dir = -1
	if key = "right" then dir = 1

	btnCount = m.buttons.count()

	if m.focusIndex = -1 then
		if dir = 1 then
			idx = firstVisibleIndex()
		else
			idx = lastVisibleIndex()
		end if
		if idx <> -1 then giveFocus(idx)
		return true
	end if

	idx = m.focusIndex + dir
	while idx >= 0 and idx < btnCount
		if m.buttons[idx].visible then
			giveFocus(idx)
			exit while
		end if
		idx += dir
	end while

	return true
end function


sub updateUI()
	m.counterLabel.text = m.counter.ToStr()
	m.resetBtn.visible  = m.counter > 0
   m.dynamicResetBtn.visible = m.counter > 0  

	if (m.focusIndex <> -1) and (not m.buttons[m.focusIndex].visible)
		m.focusIndex = -1         
		m.top.setFocus(true)
	end if
end sub


sub giveFocus(idx as integer)
	m.buttons[idx].setFocus(true)
	m.focusIndex = idx
end sub

function firstVisibleIndex() as integer
	for i = 0 to m.buttons.count()-1
		if m.buttons[i].visible then return i
	end for
	return -1
end function

function lastVisibleIndex() as integer
	for i = m.buttons.count() - 1 to 0 step -1
		if m.buttons[i].visible then return i
	end for
	return -1
end function
