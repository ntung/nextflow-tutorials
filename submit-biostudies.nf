params.input = "work/4b/f05e21cb1af45528bf4e66e45c7680/MODEL2111090001.json"
input_ch = Channel.fromPath(params.input)

params.modelId = "MODEL2111090001"

process downloadModel {
	input:
	def modelId

	output:
	path 'model_*'

	script:
	def idx = String.format("%06d", task.index)

	"""
	wget -O '${params.modelId}'.json https://wwwdev.ebi.ac.uk/biomodels/'${params.modelId}'?format=json
	printf ${idx}
	"""
}

process handleSubmission {
	input:
	path file

	output:
	stdout

	script:
	//def idx = String.format("%06d", hash)

	"""
	printf '${hash}\n'
	cat '${file}' | jq
	"""
}

workflow  {
	downloadModel
	handleSubmission(input_ch)
	handleSubmission.out.view()
}
