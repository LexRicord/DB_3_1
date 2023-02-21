LOAD DATA
INFILE 'D:\repos\DB_3_1\db_18\import_data.txt'
DISCARDFILE 'D:\repos\DB_3_1\db_18\import_data.dis'
INTO TABLE LAB18_TABLE
FIELDS TERMINATED BY ","
(
id "round(:id, 2)",
text "upper(:text)",
date_value date "DD.MM.YYYY"
)