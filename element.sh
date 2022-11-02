#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"
ELM=$@


if [[ -z $ELM ]]; then
    echo "Please provide an element as an argument."
else

    if [[ $ELM =~ ^[0-9]+$ ]]; then
        ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE atomic_number = $ELM")
    else
        ELEMENT=$($PSQL "SELECT * FROM elements INNER JOIN properties USING(atomic_number) WHERE symbol = '$ELM' OR name = '$ELM'")
    fi


    if [[ -z $ELEMENT ]]; then
        echo "I could not find that element in the database."
    else
        echo "$ELEMENT" | while IFS="|" read NUM SYMBOL NAME MASS MELT BOIL TID
        do
            TYPE=$($PSQL "SELECT type FROM types WHERE type_id = $TID")
            echo "The element with atomic number $NUM is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
        done
    fi

fi
