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
