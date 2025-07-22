
sub init()
	_initVars()
	_attachObservers()
	_cacheButtons()

	m._focusIndex = -1
	m._counter = _loadCounterFromRegistry()


	m.top.setFocus(true)
	_updateUi()
end sub


'–––– Registry helpers ––––
function _loadCounterFromRegistry() as integer
	sec = CreateObject("roRegistrySection", "appState")
	val = sec.Read("counter")         
	if Type(val) = "Invalid" or val = invalid or val = ""  
		return 0
	end if
	return val.ToInt()
end function

sub _saveCounterToRegistry()
	sec = CreateObject("roRegistrySection", "appState")
	sec.Write("counter", m._counter.ToStr())
	sec.Flush()
end sub




'  Ініціалізація та кэшування вузлів

sub _initVars()
	m._counterLabel = m.top.findNode("counterLabel")

	m._incBtn = m.top.findNode("incBtn")
	m._decBtn = m.top.findNode("decBtn")
	m._resetBtn = m.top.findNode("resetBtn")

	m._startBtn = m.top.findNode("startBtn")
	m._stopBtn = m.top.findNode("stopBtn")

	m._mainRow = m.top.findNode("mainRow")
	m._autoRow = m.top.findNode("autoRow")

	m._autoIncTimer = m.top.findNode("autoIncTimer")

	m._dynamicResetBtn = createObject("roSGNode", "Button")
	m._dynamicResetBtn.text = "Reset [dm]"
	m._dynamicResetBtn.visible = false
	m._mainRow.appendChild(m._dynamicResetBtn)
end sub



sub _attachObservers()
	m._incBtn.observeField("buttonSelected", "_onIncrement")
	m._decBtn.observeField("buttonSelected", "_onDecrement")
	m._resetBtn.observeField("buttonSelected", "_onReset")
	m._dynamicResetBtn.observeField("buttonSelected", "_onReset")

	m._startBtn.observeField("buttonSelected", "_onStart")
	m._stopBtn.observeField("buttonSelected",  "_onStop")

	m._autoIncTimer.observeField("fire", "_onTimerFire")
end sub


sub _cacheButtons()
	m._buttons = []
	for i = 0 to m._mainRow.getChildCount() - 1
		m._buttons.push(m._mainRow.getChild(i))
	end for

	for i = 0 to m._autoRow.getChildCount() - 1
		m._buttons.push(m._autoRow.getChild(i))
	end for
end sub



'  Обробники натискання кнопок

sub _onIncrement()
	m._counter += 1
	_saveCounterToRegistry()
	_updateUi()
end sub

sub _onDecrement()
	if m._counter > 0 then
		m._counter -= 1
		_saveCounterToRegistry()
		_updateUi()
	end if
end sub

sub _onReset()
	m._counter = 0
	_saveCounterToRegistry()
	_updateUi()
end sub


'– таймер –
sub _onStart()
	m._autoIncTimer.running = true
	_updateUi()
end sub

sub _onStop()
	m._autoIncTimer.running = false
	_updateUi()
end sub

sub _onTimerFire()
	_saveCounterToRegistry()
	m._counter += 1
	_updateUi()
end sub


'  Обробка клавіш ← / →

function onKeyEvent(key as String, press as Boolean) as Boolean
	if not press
		return false
	end if

	if key <> "left" and key <> "right"
		return false
	end if

	dir = -1 
	if key = "right"
		dir = 1
	end if

	btnCount = m._buttons.count()

	if m._focusIndex = -1 then
		if (dir = 1) 
			idx = _firstVisibleIndex() 
		else
			idx = _lastVisibleIndex()
		end if
		if idx <> -1 
			_giveFocus(idx)
		end if
		return true
	end if

	idx = m._focusIndex + dir
	while idx >= 0 and idx < btnCount
		if m._buttons[idx].visible then
			_giveFocus(idx)
			exit while
		end if
		idx += dir
	end while

	return true
end function


'  Допоміжні функції

sub _updateUi()
	m._counterLabel.text = m._counter.ToStr()
	m._resetBtn.visible = m._counter > 0
	m._dynamicResetBtn.visible = m._counter > 0


	if (m._focusIndex <> -1) and (not m._buttons[m._focusIndex].visible)
		m._focusIndex = -1
		m.top.setFocus(true)
	end if
end sub


sub _giveFocus(idx as Integer)
	m._buttons[idx].setFocus(true)
	m._focusIndex = idx
end sub


function _firstVisibleIndex() as Integer
	for i = 0 to m._buttons.count() - 1
		if m._buttons[i].visible
			return i
		end if
	end for
	return -1
end function

function _lastVisibleIndex() as Integer
	for i = m._buttons.count() - 1 to 0 step -1
		if m._buttons[i].visible
			return i
		end if
	end for
	return -1
end function
