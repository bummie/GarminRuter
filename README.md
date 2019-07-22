GarminRuter
==================
Widget that display info about when the bus arrives.

![GarminRuter](https://imgur.com/ypd7uzM.png)

# Launch the simulator
connectiq

# Compile the executable
monkeyc -d fenix5 -f \..\GarminRuter\monkey.jungle -o garminruter.prg -y \..\GarminRuter\developer_key.der

# Run in the simulator
monkeydo garminruter.prg fenix5