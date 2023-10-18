#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

ATOMIC_NUMBER_INPUT() {
  ATOMIC_NUMBER_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE atomic_number = $1")
  if [[ -z $ATOMIC_NUMBER_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ATOMIC_NUMBER_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME
    do
      PROPERTIES_RESULT=$($PSQL "SELECT type_id, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      if [[ -z $PROPERTIES_RESULT ]]
      then
        echo "I could not find that element in the properties table."
      else
        echo "$PROPERTIES_RESULT" | while IFS='|' read TYPE_ID ATOMIC_MASS MELTING_POINT_C BOILING_POINT_C
        do
          TYPE_RESULT=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
          if [[ -z $TYPE_RESULT ]]
          then
            echo "I could not find that type in the types table."
          else
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_RESULT, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius."
          fi
        done
      fi
    done
  fi
}

ATOMIC_SYMBOL_INPUT() {
  ATOMIC_SYMBOL_RESULT=$($PSQL "SELECT atomic_number, symbol, name FROM elements WHERE symbol = '$1'")
  if [[ -z $ATOMIC_SYMBOL_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$ATOMIC_SYMBOL_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME
    do
      PROPERTIES_RESULT=$($PSQL "SELECT type_id, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      if [[ -z $PROPERTIES_RESULT ]]
      then
        echo "I could not find that element in the properties table."
      else
        echo "$PROPERTIES_RESULT" | while IFS='|' read TYPE_ID ATOMIC_MASS MELTING_POINT_C BOILING_POINT_C
        do
          TYPE_RESULT=$($PSQL "SELECT type FROM types WHERE type_id = $TYPE_ID")
          if [[ -z $TYPE_RESULT ]]
          then
            echo "I could not find that type in the types table."
          else
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_RESULT, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius."
          fi
        done
      fi
    done
  fi
}

ELEMENT_NAME_INPUT() {
  NAME_RESULT=$($PSQL "SELECT * FROM elements WHERE name = '$1'")
  if [[ -z $NAME_RESULT ]]
  then
    echo "I could not find that element in the database."
  else
    echo "$NAME_RESULT" | while IFS='|' read ATOMIC_NUMBER SYMBOL NAME
    do
      PROPERTIES_RESULT=$($PSQL "SELECT type_id, atomic_mass, melting_point_celsius, boiling_point_celsius FROM properties WHERE atomic_number = $ATOMIC_NUMBER")
      if [[ -z $PROPERTIES_RESULT ]]
      then
        echo "I could not find that element in the properties table."
      else
        echo "$PROPERTIES_RESULT" | while IFS='|' read TYPE_ID ATOMIC_MASS MELTING_POINT_C BOILING_POINT_C
        do
          TYPE_RESULT=$($PSQL "SELECT type FROM types WHERE type_Id = $TYPE_ID")
          if [[ -z $TYPE_RESULT ]]
          then
            echo "I could not find that type in the types table."
          else
            echo "The element with atomic number $ATOMIC_NUMBER is $NAME ($SYMBOL). It's a $TYPE_RESULT, with a mass of $ATOMIC_MASS amu. $NAME has a melting point of $MELTING_POINT_C celsius and a boiling point of $BOILING_POINT_C celsius."
          fi
        done
      fi
    done
  fi
}

if [[ -z $1 ]]
then
  echo "Please provide an element as an argument."
else
  if [[ $1 =~ ^[0-9]+$ ]]
  then
    ATOMIC_NUMBER_INPUT $1
  elif [[ $1 =~ ^[A-Za-z]{1,2}$ ]]
  then
    ATOMIC_SYMBOL_INPUT $1
  else
    ELEMENT_NAME_INPUT $1
  fi
fi
