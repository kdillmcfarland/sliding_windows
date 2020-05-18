# sliding_windows
Bash script to create sliding windows from fasta files

## Directions

The basic syntax of the script is as follows. **Be sure to change the `.sh` file name to the most recent version number.**

```
bash fasta_windows_v1.1.sh <fasta> <window size> <slide size>
```

where the input fasta file is formatted with 1 line starting with `>` for each name and 1 line for each sequence. The window size is the length of desired window sequences in bp, and the slide size is the length to slide each window over in bp. Alignment formating `-` will be automatically removed.

Example fasta input

```
>Example sequence 1
AUAGGCGGCGCAUGAGAGAAGCCCAGACC-AAUUACCUACCCAAAA-UGGAGAAAGUUCACGUUGACAUCGAGGA
>Example sequence 2
UCACGUUGACAUCGAGGAAGACAGCCCAUUCCUCAGAGCUUUGCAGCGGAGCUUCCCGCAGUUUGAGGUAGAAGC
```

If you have multiple fastas, you can concatenate them together with the following. The `*` is a wildcard that stands for any character of any length, so the following captures all `.fasta` files in the directory specificed.

```
cat folder_with_fastas/*.fasta >> all.sequences.fasta
```

Then run your sequences! Here is an example process if you place your files on your computer's desktop. Results will be saved to your desktop.

```
cd Desktop/

bash fasta_windows_v1.0.sh example.fasta 50 50
```

Or you can be in any directory on your computer and use full file paths. In this case, the results will be saved in whatever folder your terminal is currently in (check where this is with `pwd` for print working directory). Note that `\` are used to split commands across multiple lines.

```
bash /Users/kim/Desktop/fasta_windows_v1.0.sh \
     /Users/kim/Desktop/example.fasta 50 50
```

In either case, the script outputs a file named `window_example.fasta` which contains the window sequences named with `window_start_end_sequenceName`

Example result

```
>window_1_50_Example sequence 1
AUAGGCGGCGCAUGAGAGAAGCCCAGACCAAUUACCUACCCAAAAUGGAG
>window_-49_0_Example sequence 1
AUAGGCGGCGCAUGAGAGAAGCCCAGACCAAUUACCUACCCAAAAUGGAG
>window_1_50_Example sequence 2
UCACGUUGACAUCGAGGAAGACAGCCCAUUCCUCAGAGCUUUGCAGCGGA
>window_-49_0_Example sequence 2
UCACGUUGACAUCGAGGAAGACAGCCCAUUCCUCAGAGCUUUGCAGCGGA
```