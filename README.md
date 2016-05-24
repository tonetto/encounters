# encounters

Captures Management Frames using *tcpdump*.

## Installation

### Linux

```
sudo apt-get install tcpdump
sudo groupadd tcpdump
sudo addgroup <username> tcpdump
sudo chown root.tcpdump /usr/sbin/tcpdump
sudo chmod 0750 tcpdump
sudo setcap "CAP_NET_RAW+eip" /usr/sbin/tcpdump
```

### OS X

*tcpdump* should already be available. To allow channel hopping, run the following:

```
sudo ln -s /System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport /usr/local/sbin/airport
sudo visudo
```

At the following line to the end of your */etc/sudoers* file:

```
%sudo ALL=NOPASSWD: /usr/local/sbin/airport
```

### Testing before running

Try the following command to check if your installation is done.

```
tcpdump -i en1 -I type mgt -e
```

You should see some output from *tcpdump*, if so we are ready to go.

## Running

As simple as:
```
git clone https://github.com/tonetto/encounters.git
cd encounters
chmod a+x encounters
./encounters --help
```

If it all went fine you should see the following output:
```
./encounters --help
usage: encounter -o </output/path> -i <wlan0> [-m]| [-h]
                 -o | --output:  /output/path for tcpdump
                 -i | --interface: <wlan0> interface
                 -m | --mapping: mapping mode (check README)
                 -h | --help: shows this message
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

## Mapping Mode

![](images/Encounters.png)

The aim of this **Mapping Mode** is to allow us to *map* access points closer to each metro/train station. To use it, add the flag *-m* to the execution line. For example:

```
$ ./encounters -i en1 -o ./tmp/ -m
```

Note that now, as soon as this command is executed, two new lines will appear on the console:

```
...
Mode: Mapping
Initial state: STOPPED
...
```

The script considers that the initial *state* you are in is STOPPED. To change *state*, hit any key on your keyboard (e.g.: SPACE or ENTER). These states refer to:
* MOVING: any given moment when you are inside the train/metro with the doors closed. Any other moment should be STOPPED, as described below.
* STOPPED: if the train/metro is not moving and has its doors open, allowing passengers to go in and out, or you are waiting outside for a new train, or you are walking from one platform to another. In case it stops between stations, DO NOT change it to STOPPED.

Also note that, as you hit a new key, the new state should be printed on the console. You MUST have the console in which the script is running for it to work. This script will not capture keyboard events otherwise.

This will create a separate file inside the same output directory. For example:
```
$ ls tmp/
1464046737.capture 1464046737.mapping
```

We recommend the use of this Channel Hopping option along with Mapping Mode.

## Channel Hopping

[]!(images/wifi_channels.png)

This allows us to control and change periodically the channel to which your wifi card is listening to. Note that on OS X this will force your WiFi card to disconnect from any access point it could have been connected at the moment. Please consider using this option since it allows us to cover all the available spectrum as well as maximizes the chances of logging from different sources.

To run it, add the *-c* as follows:

```
$ ./encounters -i en1 -o ./tmp/ -c
```

## Further instructions

As soon as you run this, please send to me files that were created. For any further questions, please just ask.
