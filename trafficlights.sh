#!/bin/bash

# TODO refactoring

# Common path for all GPIO access
BASE_GPIO_PATH=/sys/class/gpio

# Assign names to GPIO pin numbers for each light
RED=9
YELLOW=10
GREEN=11

# Assign names to states
ON="1"
OFF="0"

# Export pins so that we can use them
if [ ! -e $BASE_GPIO_PATH/gpio$RED ]; then
  echo "$RED" > $BASE_GPIO_PATH/export
fi

if [ ! -e $BASE_GPIO_PATH/gpio$YELLOW ]; then
  echo "$YELLOW" > $BASE_GPIO_PATH/export
fi

if [ ! -e $BASE_GPIO_PATH/gpio$GREEN ]; then
  echo "$GREEN" > $BASE_GPIO_PATH/export
fi

# Set pins as outputs
echo "out" > $BASE_GPIO_PATH/gpio$RED/direction
echo "out" > $BASE_GPIO_PATH/gpio$YELLOW/direction
echo "out" > $BASE_GPIO_PATH/gpio$GREEN/direction

# Turn pins off
echo $OFF > $BASE_GPIO_PATH/gpio$RED/value
echo $OFF > $BASE_GPIO_PATH/gpio$YELLOW/value 
echo $OFF > $BASE_GPIO_PATH/gpio$GREEN/value 

while [ 1 ]
do
  # Red
  echo $ON > $BASE_GPIO_PATH/gpio$RED/value 
  sleep 3

  # Red and Yellow
  echo $ON > $BASE_GPIO_PATH/gpio$YELLOW/value 
  sleep 1

  # Green
  echo $OFF > $BASE_GPIO_PATH/gpio$RED/value
  echo $OFF > $BASE_GPIO_PATH/gpio$YELLOW/value
  echo $ON > $BASE_GPIO_PATH/gpio$GREEN/value
  sleep 5
 
  # Yellow
  echo $OFF > $BASE_GPIO_PATH/gpio$GREEN/value
  echo $ON > $BASE_GPIO_PATH/gpio$YELLOW/value
  sleep 2

  # Yellow off
  echo $OFF > $BASE_GPIO_PATH/gpio$YELLOW/value
done

# TODO cleanup on exit...
