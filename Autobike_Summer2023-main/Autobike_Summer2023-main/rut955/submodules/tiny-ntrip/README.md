# tiny-ntrip

tiny-ntrip is a small NTRIP 2.0 client.

## Usage

<!-- usage-marker -->
```
./tiny-ntrip --server SERVER --port PORT --mount MOUNT ...
  --server SERVER     the IP of the NTRIP server
  --port PORT         the port of the NTRIP server
  --mount MOUNT       the mount point or stream of the desired data set
  --device DEVICE     the path of the nmea device
  --user USER         the username used for authenticatation to the NTRIP server
  --password PASSWORD the password used for authenticatation to the NTRIP server
  --interval INTERVAL the number of seconds to delay between readings of new NTRIP data
  --verbose           enable verbose output
  --help -h           prints this help text
```

## Building

Clone this repository then run
```bash
make
```

To compile with a user-specified compiler run
```bash
make CC=<my-compiler>
```

To supply additional compiler flags run
```bash
make CFLAGS=<my-compiler-flags> LDFLAGS=<my-linker-flags>
```
this may be useful for example when compiling for integrated systems like routers where the `LDFLAGS=-static` may be supplied.
