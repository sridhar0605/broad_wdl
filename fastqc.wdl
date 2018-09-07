workflow Fastqc {
	call processfastqc

}

task processfastqc {
	File fq_file
	String outputdir

	command {
	/gscmnt/gc2733/walter/sridnona/softwares/FastQC/FastQC/fastqc ${fq_file} -o ${outputdir}
	}
}