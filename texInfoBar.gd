extends NinePatchRect

onready var Globals = get_tree().get_root().get_node("Game/Globals")

var infoNode = null
var functionYet = false
var processDisplay = 0

func _process(_delta):
	updateInfo()

func updateInfo():
	
	if Globals.displayInfoMode == false:
		infoNode = null
	
	if infoNode == null:
		$hgrdName.visible = false
		$hgrdProcess.visible = false
		return
	
	$hgrdName.visible = true
	$hgrdProcess.visible = true
	$hgrdName/labName.text = " "+infoNode.entityName
	
	if infoNode.entityType == "Structure":
		
		$hgrdName/labType.text = "("+infoNode.structureType+") "
		
		if infoNode.structureType == "Processor":
			
			$hgrdProcess/ctrlLeftProcess/btnLeft.visible = true 	# We need process change
			$hgrdProcess/ctrlRightProcess/btnRight.visible = true 	# We need process change
			
			var currentProcess = infoNode.processData[infoNode.processIndex] # Get the processData for the current
			
			# Colour modulate the process change buttons
			if infoNode.processIndex < infoNode.processData.size()-1:
				$hgrdProcess/ctrlRightProcess/btnRight.modulate = Color(1,1,1)
			else:
				$hgrdProcess/ctrlRightProcess/btnRight.modulate = Color(0.3,0.3,0.3)
			if 0 < infoNode.processIndex:
				$hgrdProcess/ctrlLeftProcess/btnLeft.modulate = Color(1,1,1)
			else:
				$hgrdProcess/ctrlLeftProcess/btnLeft.modulate = Color(0.3,0.3,0.3)
			
			# Handle Inputs
			var vgrdInputList = $hgrdProcess/vgrdInputList # The vertical stack of input buffers
			for inputPos in range(3):
				var hgrdInput = vgrdInputList.get_node("hgrdInput"+str(inputPos+1)) # Individual Input Buffer
				if inputPos < currentProcess["inputBuffers"].size(): # If we still have an input buffer to display
					var bufferInfo = currentProcess["inputBuffers"][inputPos] # Get the buffer data
					hgrdInput.visible = true
					hgrdInput.get_node("labCurrent").text = str(bufferInfo["bufferCurrent"])
					hgrdInput.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					hgrdInput.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
				else:
					hgrdInput.visible = false
			
			# Handle Process
			var vgrdProcess = $hgrdProcess/vgrdProcess # The vertical stack of process info
			vgrdProcess.visible = true
			var labProcess = vgrdProcess.get_node("tmpProcess/labProcess")
			labProcess.text = "-[" + str(currentProcess["processTime"]) + "]->"
			if infoNode.isProcessing == true:
				labProcess.percent_visible = infoNode.progPerc
			else:
				labProcess.percent_visible = 1
			
			# Handle Outputs
			var vgrdOutputList = $hgrdProcess/vgrdOutputList # The vertical stack of output buffers
			vgrdOutputList.visible = true
			for outputPos in range(3):
				var hgrdOutput = vgrdOutputList.get_node("hgrdOutput"+str(outputPos+1))
				if outputPos < currentProcess["outputBuffers"].size():
					hgrdOutput.visible = true
					var bufferInfo = currentProcess["outputBuffers"][outputPos]
					hgrdOutput.get_node("labCurrent").text = str(bufferInfo["bufferCurrent"])
					hgrdOutput.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					hgrdOutput.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
				else:
					hgrdOutput.visible = false
		
		elif infoNode.structureType == "Holder":
			
			$hgrdProcess/vgrdProcess.visible = false 				# We dont need process
			$hgrdProcess/vgrdOutputList.visible = false 			# We don't need output buffers
			$hgrdProcess/ctrlLeftProcess/btnLeft.visible = false 	# We don't need process change
			$hgrdProcess/ctrlRightProcess/btnRight.visible = false 	# We don't need process change
			
			# Handle Inputs
			var vgrdInputList = $hgrdProcess/vgrdInputList # The vertical stack of input buffers
			for inputPos in range(3):
				var hgrdInput = vgrdInputList.get_node("hgrdInput"+str(inputPos+1)) # Individual internal Buffer
				if inputPos < infoNode.internalStorage.size(): # If we still have an internal buffer to display
					var bufferInfo = infoNode.internalStorage[inputPos] # Get the buffer data
					hgrdInput.visible = true
					hgrdInput.get_node("labCurrent").text = str(bufferInfo["bufferCurrent"])
					hgrdInput.get_node("labCapacity").text = str(bufferInfo["bufferMax"])
					if bufferInfo["resourceName"] == "":
						hgrdInput.get_node("texResource").texture = load("res://Assets/Resources/img_empty_"+bufferInfo["resourceType"].to_lower()+".png")
					else:
						hgrdInput.get_node("texResource").texture = load("res://Assets/Resources/img_"+bufferInfo["resourceName"].to_lower()+".png")
				else:
					hgrdInput.visible = false
		
		# Regardless of StructureType draw the image
		$hgrdProcess/texStructure.texture = infoNode.get_node("sprStructure").texture
	
	elif infoNode.entityType == "Connector":
		
		$hgrdName/labType.text = "("+infoNode.connectorType+") "
		
		if infoNode.connectorType == "Conveyor":
			
			pass

func _on_btnLeft_pressed():
	if infoNode.isProcessing == true:
		return
	if infoNode.processIndex > 0:
		infoNode.processIndex -= 1


func _on_btnRight_pressed():
	if infoNode.isProcessing == true:
		return
	if infoNode.processIndex < infoNode.processData.size()-1:
		infoNode.processIndex += 1
