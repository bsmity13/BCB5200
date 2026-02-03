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
