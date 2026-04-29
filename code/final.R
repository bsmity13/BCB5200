# Order students for mid-term presentations

# Remote students first, then Moscow students

# Load student roster
stud <- read.csv("../Students/Roster.csv")

# Remote
rem <- stud[stud$Remote, ]

# Moscow
mosc <- stud[!stud$Remote, ]

# Order presenters
set.seed(20260429)
rem$order <- sample(1:nrow(rem), size = nrow(rem), replace = FALSE)
mosc$order <- sample((nrow(rem) + 1):(nrow(rem) + nrow(mosc)),
                     size = nrow(mosc), replace = FALSE)

# Combine
stud <- rbind(rem, mosc)
stud <- stud[order(stud$order), c("order", "First", "Last")]

# Timeslots
times <- data.frame(order = 1:15,
                    date = as.Date(c(
                      rep("2026-05-05", 8),
                      rep("2026-05-07", 7)
                    )),
                    time = c(
                      seq(as.POSIXct("2026-05-05 14:03:00"),
                          by = "9 min",
                          length.out = 8),
                      seq(as.POSIXct("2026-05-07 14:03:00"),
                          by = "9 min",
                          length.out = 7))
)

# Merge
timeslots <- merge(times, stud)
timeslots$time <- format(timeslots$time, "%H:%M")

# Save
write.csv(timeslots, "../Students/final_pres.csv", row.names = FALSE)
