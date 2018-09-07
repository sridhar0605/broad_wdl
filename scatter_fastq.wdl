workflow Fastqc {
	File Samplesheet
	File fq_file
	String outputdir
	String inputdir
	

	Array[Array[String]] inputData = read_tsv(Samplesheet)


	scatter (samples in inputData) {
		call processfastqc {
			input: inputDir = inputdir,
				   in_sample1 = samples + "_R1.fq.gz",
				   in_sample2 = samples + "_R2.fq.gz",
				   outdiir = outputdir 
	}

  }

}

task processfastqc {
	String inputDir
	String in_sample1
	String in_sample2
	String outdir

	command {
	fastqc ${inputDir}/${in_sample1} ${inputDir}/${in_sample2} -o ${outdir}
	}

	runtime {
	docker_image: "sridnona/crispresso:v16"
    cpu: "1"
    memory_gb: "8"
    queue: "research-hpc"
    resource: "select[mem>8000] rusage[mem=8000]"
	}
}
