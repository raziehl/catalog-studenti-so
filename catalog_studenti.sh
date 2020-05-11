#!/bin/bash

cat << "EOH"
  ,ad8888ba,                                88                          
 d8"'    `"8b              ,d               88                          
d8'                        88               88                          
88            ,adPPYYba, MM88MMM ,adPPYYba, 88  ,adPPYba,   ,adPPYb,d8  
88            ""     `Y8   88    ""     `Y8 88 a8"     "8a a8"    `Y88  
Y8,           ,adPPPPP88   88    ,adPPPPP88 88 8b       d8 8b       88  
 Y8a.    .a8P 88,    ,88   88,   88,    ,88 88 "8a,   ,a8" "8a,   ,d88  
  `"Y8888Y"'  `"8bbdP"Y8   "Y888 `"8bbdP"Y8 88  `"YbbdP"'   `"YbbdP"Y8  
                                                            aa,    ,88  
                                                             "Y8bbdP"   
EOH


students=./data/students
grades=./data/grades

source ./functions.sh

if [ ! -f $f ]; then
echo "`basename $f` does not exist!" 1>&2
exit 1
fi
while true; do
  select OPTION in Display\ Students Show\ Student\ Grades Add\ Student Grade\ Student Update\ Student Remove\ Student Remove\ Grade Exit; do
  case $OPTION in
    Display\ Students) more $students;;
    Show\ Student\ Grades) show_student_grades;;
    Add\ Student) add_student;;
    Grade\ Student) grade_student;;
    Update\ Student) update_student;;
    Remove\ Student) remove_student;;
    Remove\ Grade) remove_grade;;
    Exit) echo Terminating...; exit 0;;
    *) echo "ERROR: Invalid selection";;
  esac
done
done