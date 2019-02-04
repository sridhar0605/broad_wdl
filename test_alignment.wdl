workflow hisat_align {
	
	File Samplesheet
	String outputdir
	String inputdir
	String strand

	String hisat_hg19_ref = '/gscmnt/gc2733/walter/sridnona/refs/hisat2_index/human.37.67'
	String hisat_hg19_gtf = '/gscmnt/gc2733/walter/sridnona/refs/human37.67/Homo_sapiens/Ensembl/GRCh37/Annotation/Archives/archive-2015-07-17-14-31-42/Genes/genes.gtf'
	String hisat_hg19_fa = '/gscmnt/gc2733/walter/sridnona/refs/human37.67/Homo_sapiens/Ensembl/GRCh37/Sequence/WholeGenomeFasta/genome.fa'
	String hisat_mm9_ref = '/gscmnt/gc2733/walter/sridnona/refs/hisat2_index/ens_mm9_exss'
	String hisat_mm9_gtf = '/gscmnt/gc2733/walter/sridnona/refs/ensembl/Mus_musculus.NCBIM37.67.gtf'
	String hisat_mm9_fa = '/gscmnt/gc2733/walter/sridnona/refs/ensembl/Mus_musculus/Ensembl/NCBIM37/Sequence/WholeGenomeFasta/genome.fa'

	Array[Array[String]] inputData = read_tsv(Samplesheet)

    
	scatter (samples in inputData) {

		call processfastqc {
				input: inputdir = inputdir,
					   in_sample1 = samples[0] + "_R1_001.fastq.gz",
					   in_sample2 = samples[0] + "_R2_001.fastq.gz",
					   outdir = outputdir
		}
			

		call align {
		    	input:
		    		inputdir = inputdir,
		            strand = strand,
		            outname = samples[1],
		            hisat_hg19_ref = hisat_hg19_ref,
		            in_sample1 = samples[0] + "_R1_001.fastq.gz",
					in_sample2 = samples[0] + "_R2_001.fastq.gz",
		            outdir = outputdir
		            

		}
	}
}



task processfastqc {
	String inputdir
	String in_sample1
	String in_sample2
	String outdir

	command {
	fastqc ${inputdir}/${in_sample1} ${inputdir}/${in_sample2} -o ${outdir} + "fast_qc"
	}

	runtime {
	docker_image: "sridnona/rnaseq_docker:v4"
    cpu: "1"
    memory_gb: "8"
    queue: "research-hpc"
    resource: "select[mem>8000] rusage[mem=8000]"
	}
}


task align {
	String inputdir
	String in_sample1
	String in_sample2
	String outdir
	String outname
	String strand
	String hisat_hg19_ref

	command {
	hisat2 -p 10 -q --rna-strandness ${strand} --dta  \
	--new-summary --summary-file ${outdir}/${outname}.summary.tsv \
	--met-file ${outdir}/${outname}_met_file.tsv \
	-x ${hisat_hg19_ref} \
	-1 ${inputdir}/${in_sample1} \
	-2 ${inputdir}/${in_sample2} | samtools view -Sb - | samtools sort \
	-m 1G -O bam -T temp.${outname} - > ${outdir} + "bams" + ${outname}.bam
    samtools index ${outdir} + "bams" + ${outname}.bam
	}
	
	runtime {
    docker_image: "sridnona/rnaseq_docker:v4"
    cpu: "10"
    memory_gb: "16"
    queue: "research-hpc"
    resource: "select[mem>8000] rusage[mem=8000]"
    }

    output {
    File bam = "${outname}.bam"
    File bamindex = "${outname}.bam.bai"
    }

}
