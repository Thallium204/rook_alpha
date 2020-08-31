extends "res://Scripts/classFactoryStructure.gd"
 
# Variables unique to Storage
var internalStorage = []

func _ready():
	imageDirectory += "/Holder"
	entityClass = "Holder"

func _process(_delta):
	
	for internalBuffer in internalStorage:
		if internalBuffer["bufferCurrent"] > 0:
			outputResource(internalBuffer["resourceName"],internalBuffer["resourceType"])

func configure(holderData): # Called when we want to initialise the internal structure
	
	internalStorage = holderData["internalStorage"]
	
	configure_Structure(holderData)

func updateUI(): # Called when we want to update the display nodes for the user
	
	# Update the structure image
	$sprStructure.texture = load(imageDirectory+"/img_"+entityName.to_lower()+".png")

func inputResource(resName,resType):
	return inputResource_Structure(resName,resType,internalStorage)

func outputResource(resName,resType):
	return outputResource_Structure(resName,resType,internalStorage)

func isStorageEmpty():
	for storage in internalStorage[0]:
		if storage[1] > 0:
			return false
	return true

func onPressed(tile): # Pressed Processes for all Holders
	
	# Handle structure
	onPressed_Structure(tile)

func onReleased(tile): # Released Processes for all Holders
	
	# Handle structure
	onReleased_Structure(tile)
