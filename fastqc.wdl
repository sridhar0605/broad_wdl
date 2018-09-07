workflow Fastqc {
	call processfastqc

}

task processfastqc {
	File fq_file
	String outputdir

	command {
	/sridnona/softwares/FastQC/FastQC/fastqc ${fq_file} -o ${outputdir}
	}
}
