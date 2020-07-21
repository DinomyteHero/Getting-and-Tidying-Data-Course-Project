#Used the read.table function to read all of the text files

ytrain <- read.table("./UCI HAR Dataset/train/y_train.txt")
xtrain <- read.table("./UCI HAR Dataset/train/X_train.txt")
subject_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

ytest <- read.table("./UCI HAR Dataset/test/y_test.txt")
xtest <- read.table("./UCI HAR Dataset/test/X_test.txt")
subject_test <- read.table("./UCI HAR Dataset/test/subject_test.txt")

features <- read.table("./UCI HAR Dataset/features.txt")

activity_labels <- read.table("./UCI HAR Dataset/activity_labels.txt")

#Combining the train and test files 

total_x <- rbind(xtest, xtrain)
total_y <- rbind(ytest, ytrain)
all_subject <- rbind(subject_test,subject_train)

#Added Column Names to final tables

colnames(total_x) = features[, 2]
colnames(total_y) = "activityid"
colnames(all_subject) = "subjectid"

colnames(activity_labels) = c("activityid", "activity")

#Need to combine all the datasets together

final_table <- cbind(total_x, total_y, all_subject)

#Need to make the actvityid and subjectid both factors in order to allow the mean function to work

final_table$activityid <- factor(final_table$activityid, levels = activity_labels[,1], labels = activity_labels[,2])
final_table$subjectid <- as.factor(final_table$subjectid) 

#Used the aggregate function to find the averages

new_tidy <- aggregate(. ~subjectid + activityid, final_table, mean)
new_tidy <- new_tidy[order(new_tidy$subjectid, new_tidy$activityid),]

new_tidy2 <- new_tidy[select(new_tidy$subjectid,new_tidy$activityid, contains("mean()" | "std()")),]
new_tidy2 <- select(new_tidy, matches(mean))

#Need to now create an subset to only display the mean and standard deviations while also displaying the subject id and the name of the activity for easy display
tidy_names <- colnames(new_tidy)

mean_and_std <- (grepl("activityd" , tidy_names) | grepl("subjectId" , tidy_names) | grepl("mean()" , tidy_names) | grepl("std()" , tidy_names))       
new_tidy2 <- new_tidy[, mean_and_std == TRUE]
new_tidy2$subjectid <- new_tidy$subjectid
new_tidy2$activity <- new_tidy$activityid
new_tidy2 <- new_tidy2[,c(80:81, 1:79)]

#Created a new textfile for the new table

write.table(new_tidy, "analysed_data.txt", row.names = FALSE)
