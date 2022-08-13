#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# functions
INSERT_IF_DOES_NOT_EXIST(){
  Existing=$($PSQL "SELECT name FROM $1 WHERE name='$3'")
  if [[ -z $Existing ]]
  then
    INSERT_RESPONSE=$($PSQL "INSERT INTO $1 ($2) VALUES('$3');")
  fi
}

while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    # insert team information into the teams table
    INSERT_IF_DOES_NOT_EXIST "Teams" "Name" "$WINNER"
    INSERT_IF_DOES_NOT_EXIST "Teams" "Name" "$OPPONENT"
    # insert game information into the games table
    WINNER_ID=$($PSQL "SELECT team_id FROM Teams WHERE name='$WINNER'")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM Teams WHERE name='$OPPONENT'")
    INSERT_RESPONSE=$($PSQL "INSERT INTO Games (year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
  fi
done < games.csv
