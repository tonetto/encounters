# encounters

Captures Management Frames using *tcpdump*.

## ALL in a nutshell

```
git clone https://github.com/tonetto/encounters.git
cd ./encounters/
./setup
./encounters -i < interface > -c
```

## Installation

```
git clone https://github.com/tonetto/encounters.git
cd ./encounters/
./setup
```
Optionally for linux users, if you are sure you already have tcpdump and iwconfig (wireless tools) you can run the setup with:

```
./setup --skip-install
```

### Testing before running

Check what is/are your wireless interfaces available:

```
# Mac OS
networksetup listallhardwareports | grep -A2 "Wi-Fi"

# Linux
sudo iw dev
```

Then run `tcpdump` with the correct wireless interface:

```
# Mac OS
tcpdump -i < interface > -I type mgt -e

# Linux
sudo tcpdump -i < interface > -I type mgt -e
```
You should see some output from `tcpdump`, if so we are ready to go.

## Running

```
$ ./encounters --help
usage: encounter -o </output/path> -i <wlan0> [-c] | [-h]

                 -o | --output:    /output/path for tcpdump
                 -i | --interface: <wlan0> interface
                 -h | --help:      shows this message
                 -c | --chanhop:   Channel Hopper (check README)
```

As suggested, indicate your wireless network interface (-i) and the path for the output file (-o). For example:

```
$ ./encounters -i en1 -o ./tmp/
```

This should create a file with a time epoch as its name, inside the ./tmp directory. For example:

```
$ ls tmp/
1464046737.capture
```

## Channel Hopping

![](images/wifi_channels.png)

This allows us to control and change periodically the channel to which your wifi card is listening to. Note that on OS X this will force your WiFi card to disconnect from any access point it could have been connected at the moment. Please consider using this option since it allows us to cover all the available spectrum as well as maximizes the chances of logging from different sources.

To run it, add the *-c* as follows:

```
$ ./encounters -i en1 -o ./tmp/ -c
```

## Further instructions

As soon as you run this, please send to me files that were created. For any further questions, please just ask.
