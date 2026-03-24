# Convert PDF to PNG using ImageMagick.
# Note, this required both ImageMagick and Ghostscript to be installed.

# Figures from Munzner textbook are available on her website as PDF.
# https://www.cs.ubc.ca/~tmm/vadbook/figures.html

# Just an example; paths not correct from this directory
"magick -density 300 -quality 95 fig2_1.pdf fig2_1.png"

# Convert Fig. 2.1 parts ----
# Base file names
parts_2.1 <- paste0("fig2_1", letters[1:6])
# Add the cropped tables figure
parts_2.1 <- c(parts_2.1, "fig2_1c_tables")

# Create commands
cmds_2.1 <- paste0("magick -density 300 -quality 95 ",
                   "lectures/fig/", parts_2.1, ".pdf ",
                   "lectures/fig/", parts_2.1, ".png")

# Execute
lapply(cmds_2.1, function(x) shell(x))

###########################################################################X
# After completing Fig. 2.1, I downloaded a single ZIP file of all
# figures from the VAD book (https://www.cs.ubc.ca/~tmm/vadbook/#figures).
# I moved the PDF directory to outside the git repo, and will copy figures
# from there to here as I convert them.
###########################################################################X

# Convert for Chapter 5 ----
# PDF directory
pdf_dir <- "../alldiagrams/"

# Chapter 5 figures
ch5_base <- list.files(pdf_dir, pattern = glob2rx("fig5.*"))

# Chapter 5 PDF paths
ch5_pdf <- paste0(pdf_dir, ch5_base)

# PNG output
ch5_png <- paste0("lectures/fig/", gsub(".pdf", ".png", ch5_base))

# Create commands
ch5_cmds <- paste0("magick -density 300 -quality 95 ",
                   ch5_pdf, " ",
                   ch5_png)

# Execute
lapply(ch5_cmds, function(x) shell(x))

# Convert for Chapter 6 ----
# PDF directory
pdf_dir <- "../alldiagrams/"

# Chapter 6 figures
ch6_base <- list.files(pdf_dir, pattern = glob2rx("fig6.*"))

# Chapter 6 PDF paths
ch6_pdf <- paste0(pdf_dir, ch6_base)

# PNG output
ch6_png <- paste0("lectures/fig/", gsub(".pdf", ".png", ch6_base))

# Create commands
ch6_cmds <- paste0("magick -density 300 -quality 95 ",
                   ch6_pdf, " ",
                   ch6_png)

# Execute
lapply(ch6_cmds, function(x) shell(x))

# Convert for Chapter 7 ----

# Chapter 7 figures
ch7_base <- list.files(pdf_dir, pattern = glob2rx("fig7.*"))

# Chapter 7 PDF paths
ch7_pdf <- paste0(pdf_dir, ch7_base)

# PNG output
ch7_png <- paste0("lectures/fig/", gsub(".pdf", ".png", ch7_base))

# Create commands
ch7_cmds <- paste0("magick -density 300 -quality 95 ",
                   ch7_pdf, " ",
                   ch7_png)

# Execute
lapply(ch7_cmds, function(x) shell(x))

# Convert for Chapter 12 ----

# Chapter 12 figures
ch12_base <- list.files(pdf_dir, pattern = glob2rx("fig12.*"))

# Chapter 12 PDF paths
ch12_pdf <- paste0(pdf_dir, ch12_base)

# PNG output
ch12_png <- paste0("lectures/fig/", gsub(".pdf", ".png", ch12_base))

# Create commands
ch12_cmds <- paste0("magick -density 300 -quality 95 ",
                    ch12_pdf, " ",
                    ch12_png)

# Execute
lapply(ch12_cmds, function(x) shell(x))


# Convert for Chapter 10 ----
# PDF directory
pdf_dir <- "../alldiagrams/"

# Chapter 10 figures
ch10_base <- list.files(pdf_dir, pattern = glob2rx("fig10.*"))

# Chapter 10 PDF paths
ch10_pdf <- paste0(pdf_dir, ch10_base)

# PNG output
ch10_png <- paste0("lectures/fig/", gsub(".pdf", ".png", ch10_base))

# Create commands
ch10_cmds <- paste0("magick -density 300 -quality 95 ",
                    ch10_pdf, " ",
                    ch10_png)

# Execute
lapply(ch10_cmds, function(x) shell(x))
