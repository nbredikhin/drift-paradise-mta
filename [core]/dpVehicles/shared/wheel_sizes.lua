local sizes = {
	[411] = 0.65 -- miata
}

function getModelDefaultWheelsSize(model)
	if not sizes[model] then
		return 0.69
	else
		return sizes[model]
	end
end