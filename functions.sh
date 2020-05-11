#!/bin/bash

function add_student() {
  while true; do
    echo
    read -p "Nume si prenume student: " name
    read -p "Grupa:" group
    read -p "Enrollment Date (dd/mm/yyyy): " enrollment_date
    data=$((RANDOM)):$name:$group:$enrollment_date
    echo
    read -p "The data is correct?(Y/n)" yn
    yn=${yn:-y}
    if [ $yn != Y ] && [ $yn != y ]; then
      return
    fi
    echo -e "\nAdding info to the database..."
    echo $data >> $students
    sort -u $students -o $students
    echo -e "\nDo you want to continue?(Y/n)"
    read yn
    yn=${yn:-y}
    if [ ! $yn = Y ] && [ ! $yn = y ]; then
      return
    fi
  done
}

function grade_student() {
  while true; do
    echo
    echo 'What student do you want to grade?'
    select STUDENT in $(cat $students | sed -e 's/ //g' | cut -d ':' -f 1,2); do
      echo
      echo Selected student: "$STUDENT"
      student_id=$(echo "$STUDENT" | cut -d ':' -f 1)
      echo
      read -p "Materie: " subject
      read -p "Nota: " grade
      grade_entry=$((RANDOM)):$subject:$grade:$student_id
      echo
      read -p "The data is correct?(Y/n)" yn
      yn=${yn:-y}
      if [ $yn != Y ] && [ $yn != y ]; then
        return
      fi
      echo "$grade_entry" >> $grades
      sort -u $grades -o $grades
      echo
      echo "Do you want to continue?(Y/n)"
      read yn
      yn=${yn:-y}
      if [ ! $yn = Y ] && [ ! $yn = y ]; then
        return
      fi
    done
  done
}

function remove_student() {
  echo -e "\nEnter name to delete (<ENTER> to exit): \c"
  read name
  if [ "$name" = "" ]; then 
    continue
  fi
  STUDENT=$(grep -i "$name" $students)
  student_id=$(echo $STUDENT | cut -d ':' -f 1)
  student_name=$(echo $STUDENT | cut -d ':' -f 2)

  sed /"$student_name"/d $students > tmp
  mv tmp $students
  sed /"$student_id"/d $grades > tmp
  mv tmp $grades
  echo "\nStudent and grades associeated removed"
}

function remove_grade() {
  echo
  cat $grades
  echo -e "\nEnter id of grade to delete (<ENTER> to exit): \c"
  read id
  if [ "$id" = "" ]; then 
    continue
  fi
  sed -e /"$id"/d $grades > tmp
  mv tmp $grades
  cat $grades
  echo "\nGrade removed"
}


function show_student_grades() {
  echo -e "\nEnter name to search: \c"; read name
  grep -i "$name" $students > /dev/null
  if [ "$?" -eq 0 ]; then
    STUDENT=$(grep -i "$name" $students)
    student_id=$(echo $STUDENT | cut -d ':' -f 1)
    student_name=$(echo $STUDENT | cut -d ':' -f 2)
    student_group=$(echo $STUDENT | cut -d ':' -f 3)
    student_enrollment=$(echo $STUDENT | cut -d ':' -f 4)

    GRADES=$(grep -i "$student_id" $grades | sed -e 's/ //g')

    echo "----------------------------------------------------------------------------------"
    echo ID: $student_id
    echo Name: $student_name
    echo Group: $student_group
    echo Enrollment Date: $student_enrollment
    echo "----------------------------------------------------------------------------------"
    echo
    echo -e "GradeID:Subject:Grade:StudentID\n" "$GRADES"  | column -t -s ':'

  else
    echo "$name not found!!"
  fi
    read -p "Press ENTER to continue" key
}

function update_student() {
  echo -e "\nEnter name to search: \c"; read name
  grep -i "$name" $students > /dev/null
  if [ "$?" -eq 0 ]; then
    STUDENT=$(grep -i "$name" $students)
    student_id=$(echo $STUDENT | cut -d ':' -f 1)
    student_name=$(echo $STUDENT | cut -d ':' -f 2)
    student_group=$(echo $STUDENT | cut -d ':' -f 3)
    student_enrollment=$(echo $STUDENT | cut -d ':' -f 4)
    echo
    echo "Editing Student: $STUDENT"

    select PROPERTY in Name Group Enrollment\ Date Grade Back; do
      case $PROPERTY in
      Name) update_student_value "$student_name";;
      Group) update_student_value "$student_group";;
      Enrollment\ Date) update_student_value "$student_enrollment";;
      Grade) update_grade $student_id;;
      Back) break;;
      *) echo "ERROR: Invalid selection";;
      esac
    done
  else
    echo "$name not found!!"
  fi
  echo "Going back up one level..."
}

function update_grade() {
  echo -e "\nEnter grade id to search: \c"; read id
  grep -i "$id" $grades > /dev/null
  if [ "$?" -eq 0 ]; then
    GRADE=$(grep -i "$id" $grades)
    grade_subject=$(echo $GRADE | cut -d ':' -f 2)
    grade_value=$(echo $GRADE | cut -d ':' -f 3)
    echo
    echo "Editing $GRADE"
    
    select PROPERTY in Subject Grade Break; do
      case $PROPERTY in
      Subject) update_grade_value "$grade_subject";;
      Grade) update_grade_value "$grade_value";;
      Back) break;;
      *) echo "ERROR: Invalid selection";;
      esac
    done

  else
    echo "$name not found!!"
  fi
  echo "Going back up one level..."
}

function update_student_value() {
  echo -e "Enter new value: \c"; read new_prop
  sed s/"$1"/"$new_prop"/ $students > tmp
  if [ $? -eq 0 ]; then
    echo "Ok! Change made!"
    mv tmp $students
  else
    echo "Error!"
  fi
}

function update_grade_value() {
  echo -e "Enter new value: \c"; read new_prop
  sed s/$1/"$new_prop"/ $grades > tmp
  if [ $? -eq 0 ]; then
    echo "Ok! Change made!"
    mv tmp $grades
  else
    echo "Error!"
  fi
}
