#!/bin/bash

# Common path for all GPIO access
BASE_GPIO_PATH=/sys/class/gpio

# Assign names to GPIO pin numbers for each light
RED=9
YELLOW=10
GREEN=11

# Assign names to states
ON="1"
OFF="0"

# Utility function to export a pin if not already exported
exportPin()
{
  if [ ! -e $BASE_GPIO_PATH/gpio$1 ]; then
    echo "$1" > $BASE_GPIO_PATH/export
  fi
}

# Utility function to set a pin as an output
setOutput()
{
  echo "out" > $BASE_GPIO_PATH/gpio$1/direction
}

# Utility function to change state of a light
setLightState()
{
  echo $2 > $BASE_GPIO_PATH/gpio$1/value
}

# Utility function to turn all lights off
allLightsOff()
{
  setLightState $RED $OFF
  setLightState $YELLOW $OFF
  setLightState $GREEN $OFF
}

# Ctrl-C handler for clean shutdown
shutdown()
{
  allLightsOff
  exit 0
}

trap shutdown SIGINT

# Export pins so that we can use them
exportPin $RED
exportPin $YELLOW
exportPin $GREEN

# Set pins as outputs
setOutput $RED
setOutput $YELLOW
setOutput $GREEN

# Turn lights off to begin
allLightsOff

# Loop forever until user presses Ctrl-C
while [ 1 ]
do
  # Red
  setLightState $RED $ON
  sleep 3

  # Red and Yellow
  setLightState $YELLOW $ON
  sleep 1

  # Green
  setLightState $RED $OFF
  setLightState $YELLOW $OFF
  setLightState $GREEN $ON
  sleep 5
 
  # Yellow
  setLightState $GREEN $OFF
  setLightState $YELLOW $ON
  sleep 2

  # Yellow off
  setLightState $YELLOW $OFF
done
