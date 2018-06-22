# mpileup

This is a Docker container to run the [parse_pileup_query.pl](parse_pileup_query.pl)
script.  You can connect this repository to Docker Hub as an automated build
so that the container builds automatically when you commit.

## Build

To build the container locally:

```bash
docker build -t vanessa/mpileup .
```

## Usage

### Interactive
First let's show how to interact with the container, meaning shelling inside
and looking at the software we have.

```bash
$ docker run -it --entrypoint bash vanessa/mpileup

root@34c4600bd019:~# which perl
/usr/local/bin/perl
root@34c4600bd019:~# which samtools
/usr/local/bin/samtools
```

To access data from your host in the container, you would need to bind a data folder.
Exit from the container and do this command again with `-v`, which means volume.

```bash
$ docker run -it --entrypoint bash -v $PWD/data:/tmp/data vanessa/mpileup

# Here is the mounted data!
root@b95145c080a4:~# ls /tmp/data/
test.bam  test.bam.bai	test.list.chr2.txt
```

Let's now try running the script

```bash
cd /code
perl Query_Editing_Level.GRCh37.20161110.pl /tmp/data/test.list.chr2.txt /tmp/data/test.bam /tmp/data/test.out
```

Note that the reference genome is an example, `chr2.fa` in the same directory as the script in the
container `/code`. If you want to change this file, change this line:

```bash
my $genomepath = "chr2.fa"; #PATH TO REFERENCE GENOME
```

### External
Likely you want to run this from outside the container, and to do this you will still need to bind the data,
and then reference the path in the container the data is bound to. The entrypoint to the container is the script, so if you run it without arguments,
you will see it. The same command above would look like this:

```bash
$ docker run -it -v $PWD/data:/tmp/data vanessa/mpileup
need to provide 3 input:Edit Site list, INDEXED BAM alignment file and output file name
```

And so then you can provide your data to get it running again! Note that we are providing paths to `/tmp/data`
where the container has bound to our `$PWD/data` (location on the host)

```bash
docker run -it -v $PWD/data:/tmp/data vanessa/mpileup /tmp/data/test.list.chr2.txt /tmp/data/test.bam /tmp/data/test.out
[mpileup] 1 samples in 1 input files
...
```

