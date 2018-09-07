# broad_wdl

<https://software.broadinstitute.org/wdl/documentation/topic?name=wdl-tutorials>

## Dependencies 
 * Cromwell Jar workflow management  
 <https://github.com/broadinstitute/cromwell/releases/download/31/cromwell-31.jar>

 * WOMtool Jar validates workflow script  
 <https://github.com/broadinstitute/cromwell/releases/download/31/womtool-31.jar>

 * Java 8 

 * Docker with java8
  sridnona/rnaseq_docker



### Step1
create wdl file 

### Step2
validate it 
```{shell}
java -jar $wom validate fastqc.wdl
```

### Step3
Create a json file with that would be used  
to enter sample info and paths
```{shell}
java -jar $wom inputs fastqc.wdl > fastqc.json
```

### Step4
use cromwell jar file to execute workflow
```{shell}
java -jar $crom run -i fastqc.json fastqc.wdl
```


