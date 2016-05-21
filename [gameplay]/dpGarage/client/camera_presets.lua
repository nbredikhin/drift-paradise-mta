cameraPresets = {}

cameraPresets.vehicleSelect = {
	targetPosition = Vector3(1.4, 1, 0),
	rotationHorizontal = 30,
	rotationVertical = 5,
	distance = 7,
	FOV = 50,
	roll = 0
}
cameraPresets.vehicleTuning = {
	targetPosition = Vector3(-1.3, 1, 0.5),
	rotationHorizontal = 0,
	rotationVertical = 0,
	distance = 7,
	FOV = 50,
	roll = 0
}
cameraPresets.startingCamera = {
	targetPosition = Vector3(1.4, 1, 0),
	rotationHorizontal = 20,
	rotationVertical = 5,
	distance = 14,
	FOV = 20,
	roll = 0
}

----------------------------------------------------------

-- Передний бампер
cameraPresets.frontBump = {
	targetPosition = Vector3(0, 1, 0),
	rotationHorizontal = 10,
	rotationVertical = 20,
	distance = 6,
	FOV = 50,
	roll = 0
}

-- Передний бампер при покупке
cameraPresets.previewFrontBump = {
	targetPosition = Vector3(1, 1, 0),
	rotationHorizontal = 10,
	rotationVertical = 10,
	distance = 6,
	FOV = 50,
	roll = 0
}

----------------------------------------------------------

-- Задний бампер
cameraPresets.rearBump = {
	targetPosition = Vector3(0, -1, 0),
	rotationHorizontal = 150,
	rotationVertical = 5,
	distance = 6,
	FOV = 45,
	roll = 0
}

-- Задний бампер при покупке
cameraPresets.previewRearBump = {
	targetPosition = Vector3(-0.5, -1, 0.3),
	rotationHorizontal = 160,
	rotationVertical = 0,
	distance = 5.5,
	FOV = 50,
	roll = 0
}

----------------------------------------------------------

-- Спойлер
cameraPresets.spoiler = {
	targetPosition = Vector3(0, -1, 0),
	rotationHorizontal = 220,
	rotationVertical = 20,
	distance = 5,
	FOV = 50,
	roll = 0
}

-- Спойлер при покупке
cameraPresets.previewSpoilers = {
	targetPosition = Vector3(0.6, -1, 0.4),
	rotationHorizontal = 200,
	rotationVertical = 10,
	distance = 5.5,
	FOV = 50,
	roll = 0
}

----------------------------------------------------------

-- Юбки
cameraPresets.skirts = {
	targetPosition = Vector3(0, 0, -0.2),
	rotationHorizontal = -50,
	rotationVertical = 0,
	distance = 5,
	FOV = 50,
	roll = 0
}

-- Юбки при покупке
cameraPresets.previewSideSkirts = {
	targetPosition = Vector3(0.9, -0.7, -0.2),
	rotationHorizontal = -30,
	rotationVertical = 0,
	distance = 5.5,
	FOV = 50,
	roll = 0
}

----------------------------------------------------------

-- Колесо
cameraPresets.wheelLF = {
	targetPosition = "wheel_lf_dummy",
	rotationHorizontal = 45,
	rotationVertical = 10,
	distance = 4,
	FOV = 40,
	roll = 0
}

-- Колёса при покупке
cameraPresets.previewWheels = {
	targetPosition = Vector3(-1, -0.3, -0.05),
	rotationHorizontal = 35,
	rotationVertical = 5,
	distance = 5,
	FOV = 50,
	roll = 0
}

----------------------------------------------------------

-- Задние фендеры
cameraPresets.rearFends = {
	targetPosition = Vector3(0, 0, -0.2),
	rotationHorizontal = -130,
	rotationVertical = 0,
	distance = 4.5,
	FOV = 50,
	roll = 0
}

-- Задние фендеры при покупке
cameraPresets.previewRearFends = {
	targetPosition = Vector3(0.8, 0.5, -0.1),
	rotationHorizontal = -140,
	rotationVertical = 0,
	distance = 5.5,
	FOV = 50,
	roll = 0
}

----------------------------------------------------------

-- Передние фендеры
cameraPresets.frontFends = {
	targetPosition = Vector3(0, 0.5, -0.2),
	rotationHorizontal = -40,
	rotationVertical = 0,
	distance = 4.5,
	FOV = 50,
	roll = 0
}

-- Передние фендеры при покупке
cameraPresets.previewFrontFends = {
	targetPosition = Vector3(0.8, 0.5, -0.2),
	rotationHorizontal = -30,
	rotationVertical = 0,
	distance = 5,
	FOV = 50,
	roll = 0
}

----------------------------------------------------------

-- Капот
cameraPresets.bonnet = {
	targetPosition = Vector3(0, 1, 0),
	rotationHorizontal = -10,
	rotationVertical = 20,
	distance = 6,
	FOV = 50,
	roll = 0
}

-- Капот при покупке
cameraPresets.previewBonnets = {
	targetPosition = Vector3(1, 1, 0),
	rotationHorizontal = -10,
	rotationVertical = 10,
	distance = 6,
	FOV = 50,
	roll = 0
}

----------------------------------------------------------

-- Выхлоп
cameraPresets.exhaust = {
	targetPosition = Vector3(0, -1, -0.1),
	rotationHorizontal = 170,
	rotationVertical = 4,
	distance = 5,
	FOV = 45,
	roll = 0
}

-- Выхлоп при покупке
cameraPresets.previewExhaust = {
	targetPosition = Vector3(-0.8, -1, 0),
	rotationHorizontal = 180,
	rotationVertical = 5.5,
	distance = 6,
	FOV = 45,
	roll = 0
}

----------------------------------------------------------

-- Задние фары
cameraPresets.rearLights = {
	targetPosition = Vector3(0, -1, 0),
	rotationHorizontal = 180,
	rotationVertical = 5,
	distance = 5,
	FOV = 45,
	roll = 0
}

-- Задние фары при покупке
cameraPresets.previewRearLights = {
	targetPosition = Vector3(-0.8, -1, 0),
	rotationHorizontal = 180,
	rotationVertical = 5.5,
	distance = 6,
	FOV = 45,
	roll = 0
}

----------------------------------------------------------

-- Подвеска
cameraPresets.suspension = {
	targetPosition = Vector3(0, 0, -0.3),
	rotationHorizontal = 90,
	rotationVertical = 0,
	distance = 6,
	FOV = 55,
	roll = 0	
}

----------------------------------------------------------

-- Оффсет передних колёс
cameraPresets.wheelsOffsetFront = {
	targetPosition = "wheel_lf_dummy",
	rotationHorizontal = 30,
	rotationVertical = 20,
	distance = 4,
	FOV = 40,
	roll = 0	
}

----------------------------------------------------------

-- Оффсет задних колёс
cameraPresets.wheelsOffsetRear = {
	targetPosition = "wheel_lb_dummy",
	rotationHorizontal = 30,
	rotationVertical = 20,
	distance = 4,
	FOV = 40,
	roll = 0	
}

----------------------------------------------------------
----------------------------------------------------------
--						 ЦВЕТА 
----------------------------------------------------------
----------------------------------------------------------

cameraPresets.bodyColor = {
	targetPosition = Vector3(0, 1, 0),
	rotationHorizontal = -30,
	rotationVertical = 10,
	distance = 6,
	FOV = 50,
	roll = 0
}

cameraPresets.selectingBodyColor = {
	targetPosition = Vector3(1, 1, 0.4),
	rotationHorizontal = -20,
	rotationVertical = 5,
	distance = 6,
	FOV = 50,
	roll = 0	
}
----------------------------------------------------------
cameraPresets.selectingWheelsColor = {
	targetPosition = Vector3(-1, -0.3, -0.05),
	rotationHorizontal = 35,
	rotationVertical = 5,
	distance = 5,
	FOV = 50,
	roll = 0
}
----------------------------------------------------------
cameraPresets.selectingSpoilerColor = {
	targetPosition = Vector3(0.6, -1, 0.4),
	rotationHorizontal = 200,
	rotationVertical = 10,
	distance = 5.5,
	FOV = 50,
	roll = 0
}