#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

MAIN_MENU() {
  if [[ -z $1 ]]
  then
    echo Please provide an element as an argument.
  else
    # Controlla se l'argomento è un numero o una stringa
    if [[ $1 =~ ^[0-9]+$ ]]
      then
        ARGUMENT="elements.atomic_number = $1"
      else
        ARGUMENT="elements.symbol = '$1' OR elements.name = '$1'"
      fi

    ELEMENT=$($PSQL "SELECT * FROM properties FULL JOIN elements USING (atomic_number) FULL JOIN types USING (type_id) WHERE $ARGUMENT")
    
    if [[ -z $ELEMENT ]]
    then
      echo "I could not find that element in the database."
    else
    #echo "$CUSTOMER_RENTALS" | while read BIKE_ID BAR TYPE BAR SIZE
      IFS="|"
      echo "$ELEMENT" | while read TYPE_ID AT_NUM AT_MASS MELT_P_C BOIL_P_C SYMBOL NAME TYPE
      do
        echo -e "The element with atomic number $AT_NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $AT_MASS amu. $NAME has a melting point of $MELT_P_C celsius and a boiling point of $BOIL_P_C celsius."
        IFS=" "
      done
    fi
  fi
}

MAIN_MENU "$1"
