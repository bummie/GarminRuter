GarminRuter
==================
Widget that display info about a given bus route in Akershus.

![GarminRuter](https://i.imgur.com/1pFrLdK.png)

# Launch the simulator
connectiq

# Compile the executable
monkeyc -d fenix5 -f \..\GarminRuter\monkey.jungle -o garminruter.prg -y \..\GarminRuter\developer_key.der

# Run in the simulator
monkeydo garminruter.prg fenix5