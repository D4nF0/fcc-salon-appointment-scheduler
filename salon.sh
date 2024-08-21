#! /bin/bash

# use - psql -U postgres < salon.sql - for the rebuilding of the database

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ MY SALON ~~~~~"

MAIN_MENU() {
  if [[ -z $1 ]] 
  then
    echo -e "\nWelcome to My Salon, how can I help you?\n"
  else
    echo -e "\n$1\n"
  fi
  
  $PSQL "SELECT name, service_id FROM services" | while IFS=" " read SERVICE_NAME BAR SERVICE_ID 
  do
    if [[ ! -z $SERVICE_NAME || $SERVICE_ID ]]
    then
      echo -e "$SERVICE_ID) $SERVICE_NAME"
    fi
  done

  read SERVICE_ID_SELECTED

  case $SERVICE_ID_SELECTED in
    1) APPOINTMENT_SCHEDULER cut;;
    2) APPOINTMENT_SCHEDULER color;;
    3) APPOINTMENT_SCHEDULER style;;
    4) APPOINTMENT_SCHEDULER trim;;
    5) APPOINTMENT_SCHEDULER perm;;
    *) MAIN_MENU "I could not find that service. What would you like today?";;
  esac
}

APPOINTMENT_SCHEDULER() {
  if [[ -z $1 ]]
  then
    MAIN_MENU "Please enter desired service"
  else 
    echo -e "\nWhat's your phone number?"
    read CUSTOMER_PHONE
    CUSTOMER_NAME=$($PSQL "SELECT name FROM customers WHERE phone='$CUSTOMER_PHONE'")

    if [[ -z $CUSTOMER_NAME ]]
    then
      echo -e "\nI don't have a record for that phone number, what's your name?"
      read CUSTOMER_NAME
      
      INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers( name, phone) VALUES( '$CUSTOMER_NAME', '$CUSTOMER_PHONE')" )
    
    fi

    CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")

    echo -e "\nWhat time would you like your $1, $CUSTOMER_NAME?"
    read SERVICE_TIME

    INSERT_APPOINTMENT_RESULT=$($PSQL "INSERT INTO appointments( service_id, customer_id, time) VALUES( $SERVICE_ID_SELECTED, $CUSTOMER_ID, '$SERVICE_TIME')" )

    echo -e "\nI have put you down for a $1 at $SERVICE_TIME, $CUSTOMER_NAME."

  fi

}


MAIN_MENU
