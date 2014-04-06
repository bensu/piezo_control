ARDUINO IO (Also Known As: "TETHERED" MATLAB SUPPORT PACKAGE FOR ARDUINO):

This package allows using an Arduino connected to the computer to perform
Analog and Digital Input and Output, (and command motors) from MATLAB.

---------------------------------------------------------------------------

DETAILS ABOUT ARDUINO:

Arduino is a powerful and inexpensive open-source microcontroller board, 
with an associated development environment: http://arduino.cc/
An extensive Knowledge base can be found here: http://www.freeduino.org/


BUYING AN ARDUINO BOARD:

An extensive list of sites where you can buy an Arduino is here:
http://www.arduino.cc/en/Main/Buy

In the US, adafruit industries (http://www.adafruit.com/) 
provides a starter pack that includes pretty much everything that you
need to get started with the board.

While earlier version of this package were targeted at smaller boards like 
the Uno and Nano, since August 2012 (ver 3.3) the package also works right 
out of the box on the Mega boards, without requiring any Mega-related tweaking.


GETTING STARTED GUIDES:

The official getting started guide is here : http://arduino.cc/en/Guide/HomePage
and a very good tutorial is here: http://www.ladyada.net/learn/arduino/
However note that for the purpose of using this package you only need to have 
the IDE environment installed but you won't need to use it, because you can 
do all the programming in MATLAB.


CHIP KIT 32 BOARDS:

Note that the the package works fine with the ChipKit32 boards (Uno32, Max32):
http://www.digilentinc.com/Products/Catalog.cfm?NavPath=2,892&Cat=18
All of the analog and digital input and output functionality work fine, 
but unfortunately not all the interrupts functionalities work in the same 
way, so servos and encoders might not work exactly as on the Arduino boards.
Since Sep 2012, when the AFMotor library was updated to support PIC32, 
the Adafruit Motor Sield also works with these boards.

The Cerebot MX7ck also works fine with the package. Note that in order to be
accessed with the MPIDE you need to short jumper JP11, set the switch to ON,
and connect it to the PC through the UART (not the DEBUG) usb port.
If you don't have external power then make sure to also set the power 
jumper to UART (as opposite to the default position DBG).


TI LAUNCHPAD (MSP430) BOARDS:

Using the Energia IDE (http://energia.nu/Guide_MSP430LaunchPad.html)
the adio.pde and adioe.pde can be compiled for the MSP430G2553 and 
MSP430G2452 (the G2231 does not have enough memory). The adioes.pde sketch 
can be compiled for the FR5739. Note however that no real testing has been 
performed on these platforms though.

---------------------------------------------------------------------------

DOWNLOADING AND INSTALLING THE IDE (to be done only once):

A step by step driver installation can be found at:
http://arduino.cc/en/Guide/HomePage and there is no need to duplicate it here. 
It is a good idea to go trought all the 9 steps, although after you have 
installed the drivers, maybe the shield library, and verified that the IDE 
can communicate with the Arduino, you can already start using this package.


INSTALLING THE ADAFRUIT MOTOR SHIELD LIBRARY (to be done only once):

If you want to use this package with the ADAFRUIT motor shield, (either  
version 1: http://learn.adafruit.com/adafruit-motor-shield or version 2: 
http://learn.adafruit.com/adafruit-motor-shield-v2-for-arduino ), you need
to download and install the respective adafruit motor shield library
(follow instructions given in the above sites, which amount to download
a zip file and unzip it into the arduino-1.X/libraries folder. 

As better explained in the next step, this you will also need to upload 
eiter the motor_v1.pde or the motor_v2.pde sketch on the board.

NOTE that if you don't have the adafruit motor shield and you don't plan 
to use it, you might also SKIP THIS STEP.

Also note that the "official" Arduino (not Adafruit) motor shield:
(http://arduino.cc/it/Main/ArduinoMotorShieldR3)
does not require any additional library, works fine with the chipkit32
boards, and can be used with this package right away. Therefore if you 
plan to use the official motor shield then you can safely skip this step.

---------------------------------------------------------------------------

UPLOAD ADIOES.PDE TO THE ARDUINO BOARD (to be done only once):

The adioes.pde sketch is the "server" program that will continuously run 
on the microcontroller board. It listens for MATLAB commands arriving from 
the serial port, executes the commands, and, if needed, returns a result.

The following instructions are needed to upload the adioes.pde file into 
the controller's flash memory. As long as no other file is uploaded later, 
this step does not need to be repeated anymore, and the package can be 
used as soon as the board is connected to the computer.

Note that if you want to use the adafruit shield library then you need to 
both install the appropriate library (see previous step) and upload the 
the appropriate sketch (either motor_v1.pde or motor_v2.pde) instead of 
the adioes.pde sketch.

From the Arduino IDE, go to File > Open, locate the file adioes.pde, 
(in the ArduinoIO/pde/adioes folder) and open it. If a dialog appears 
asking for the permission to create a sketch folder and move the file, 
press OK (this will create an adioes folder and move the adioes.pde 
file inside it).

Connect the Arduino, make sure that the right board and serial port are 
selected in the IDE, (Tools/Board and Tool/Serial Port) then select 
File -> Upload to I/O Board and wait for the "Done Uploading" message.

At this point the adioes.pde file is uploaded and you can close the IDE,
which is not needed anymore for the purpose of this package. Actually 
closing the IDE is suggested, so you can be sure that the serial connection 
to the arduino board is not taken by the IDE when matlab needs to use it.

---------------------------------------------------------------------------

PACKAGE INSTALLATION (to be done only once):

When installing the Arduino IO package on your operating system it is
important that users have the right to access the serial port and modify
the pathdef.m file.


ON LINUX:
---------

To make sure that the pathdef.m file is writable, issue a command like this: 
sudo chmod 777 usr/local/matlab/R2012a/toolbox/local/pathdef.m
(modify the path above according to where MATLAB is installed). 

Also, still on Linux, create a symbolic link as follows: 
sudo ln -s /dev/ttyACM0 /dev/ttyS101 
and make sure it is accessible by any user: 
sudo chmod 777 /dev/ttyS101
Forgetting this last step might lead to a serial port which is 
unaccessible by a normal user (therefore being grayed-out in the IDE). 

Then from MATLAB, launch the "install_arduino" command, this will simply 
add the relevant ArduinoIO folders to the matlab path and save the path. 


ON WINDOWS:
-----------

Run MATLAB as administrator (just one time for the purpose of installing 
the package) by right-clicking on the MATLAB icon and selecting 
"Run as Administrator". This will allow the updated path to be saved.

Then from MATLAB, launch the "install_arduino" command, this will simply 
add the relevant ArduinoIO folders to the matlab path and save the path. 

---------------------------------------------------------------------------

TYPICAL USAGE:

Make sure the board is connected to the computer via USB port, make sure
you know which serial port the Arduino is connected to (this is the same 
port found at the end of the drivers installation step), and finally, 
make sure that the port is not used by the IDE (in other words, the IDE must
be closed or disconnected), so that MATLAB can use the serial connection.

From MATLAB, launch the command a=arduino('port') where 'port' is the
COM port to which the Arduino is connected to, e.g. 'COM5' or 'COM8' on Windows,
or '/dev/ttyS101' on Unix (use '/dev/ttyUSB0' for Arduino versions prior to Uno)
or 'DEMO' (see below for the DEMO mode) and make sure the function terminates 
successfully.

Then use the commands a.pinMode, a.digitalRead, a.digitalWrite, a.analogRead, 
and a.analogWrite, to respectively change the mode (input/output) of each pin, 
perform digital input, digital output, analog input, and analog output. 
Consult the help of the files to get more information about their usage. 

If you also have a servo motor, then you can use commands such as 
a.servoAttach, a.servoStatus, a.servoWrite, a.servoRead, and a.servoDetach
to respectively attach a servo to a PWM pin, get its status (attached/detached)
move it to a certain angle, and read its position.

NOTE that since August 2012 (ver 3.8) the servos are no longer referred by
the numbers 1 and 2 but instead by the PWM pin number to which they are 
attached (e.g. a.servoRead(9) reads the servo attached to pin #9).

For encoders you can use the commands a.encoderAttach, a.encoderStatus, 
a.encoderRead, a.encoderReset and a.encoderDetach to respectively attach an
encoder to 2 interrupt pins (2,3 on the Uno, 2,3,21,20,19,18 on the Mega)
get its status (attached/detached), read and reset its position, and 
detach it when you are done. The positive rotation directions for encoders
is assumed to be clockwise, and the range goes from -32768 to +32767,
if you need a bigger range all you have to do is to go in the Encoder 
structure typedef line of the sketch file and replace the third field, 
"int pos;" with "long int pos;".

There is a couple of other functions such as a.serial (returning the name
of the serial port), a.flush (flushing the input side of the PC's serial 
port) and a.roundTrip, which sends a value to the arduino and back.

Finally, use a.delete to delete the arduino object, (and free up the 
serial port) when the session is over.

Have a look below for an example.

---------------------------------------------------------------------------

EXAMPLE:

% connect the board
a=arduino('COM5')

% specify pin mode for pins 4, 13 and 5
pinMode(a,4,'input');
pinMode(a,13,'output');
pinMode(a,5,'output');

% read digital input from pin 4
dv=digitalRead(a,4);

% output the digital value (0 or 1) to pin 13
digitalWrite(a,13,dv);

% read analog input from analog pin 5 (physically != from digital pin 5)
av=analogRead(a,5);

% normalize av from 0:1023 to 0:254
av=(av/1023)*254;

% ouptput value on digital (pwm) pin 5 (again, different from digital pin 5)
analogWrite(a,5,round(av))

% change reference voltage for analog pins to external
analogReference(a,'external');

% change it back to default
analogReference(a,'default');

% gets the name of the serial port to which the arduino is connected to
serial(a)

% flushes the PC's serial input buffer (just in case)
flush(a);

% sends number 42 to the arduino and back (to see if it's still there)
roundTrip(a,42)

% attach servo on pin #9
servoAttach(a,9); 

% return the status of all servos
servoStatus(a); 

% rotates servo on pin #9 to 100 degrees
servoWrite(a,9,100); 

% reads angle from servo on pin #9
val=servoRead(a,9)

% detach servo from pin #9
servoDetach(a,9); 

% attach encoder #0 on pins 3 (pin A) and 2 (pin B)
encoderAttach(a,0,3,2)

% read the encoder position
encoderRead(a,0)

% attach encoder #2 on pins 18 (pin A) and 21 (pin B)
encoderAttach(a,2,18,21)

% sets debouncing delay to 17 (~1.7ms) for encoder #2
encoderDebounce(a,2,17)

% read position or encoder #2
encoderRead(a,2)

% reset position of encoder #2
encoderReset(a,2)

% get status of all three encoders
encoderStatus(a);

% detach encoder #0
encoderDetach(a,0);

% close session
delete(a)

NOTE: Should for any reason the serial port not be relaesed after you clear 
the arduino object, you can use the following commands to force the release 
ot the serial connection:

% delete MATLAB serial connection on COM3
delete(instrfind({'Port'},{'COM3'}));

% delete all MATLAB serial connections
delete(instrfind('Type', 'serial'));

Also note that due to MATLAB OO naming conventions, the first argument 
can be passed also before any function (method) name, therefore a typical
function such as: function(a,arg2,arg3,...) can also be called like this: 
a.function(arg2,arg3,...)

---------------------------------------------------------------------------

PROVIDED SKETCHES:

The following sketches are provided with the package:

-) adio.pde     : analog and digital IO, plus basic serial commands only
-) adioe.pde    : adio.pde + encoders support
-) adioes.pde   : adioe.pde + servo support
-) motor_v1.pde : adioes.pde + afmotor v1 shield
-) motor_v2.pde : adioes.pde + afmotor v2 shield

In most cases the adioes.pde will cover all you need. The last two sketches
are needed for the Adafruit Motor Shield (version 1 and 2 respectively).
The first 2 sketches are mostly provided in case your specific platform
does not support servos or encoders and as a better (simpler) starting 
point for people that want to customize a sketch for their own purposes.
In the latter case, the "roundtrip" function is probably the easiest 
place to get started to introduce custom code.

---------------------------------------------------------------------------

DEMO MODE:

Whenever 'DEMO' is specified as argument of the arduino function, i.e. 
a=arduino('DEMO') then a virtual connection is opened that does not involve 
any hardware. This allows trying the package without actually having an 
arduino board. In this mode, all the "read" functions return random values 
according to their output range. Also, delays are used internally so that 
the execution time of any function approximately matches the average 
execution time that can be observed when the actual board is connected.

Note that the same behavior (random output values) occurs when the sketch
running on the board does not support the specific operation (e.g. a servo 
read is issued but the sketch running on the board, say adio.pde) does not
support servos. 

---------------------------------------------------------------------------

BLINK CHALLENGE:

The "blink_challenge" is an example application that switches the leds on and
off with variable frequency and with mode changed by pressing a switch button
Have a look at the m file for more info, (type help blink_challenge from the 
command line) and launch blink_challenge to execute the demo.

NOTE that running this applicaton only makes sense if the Arduino board is 
connected to an appropriate circuit where digital pins 9 to 13 are configured 
as outputs and connected to leds, digital pin #2 is configured as input and
connected to a button that pulls the voltage down when pressed, and analog
pin #2 is connected to a potentiometer. Have a look at the schematics in the
blink_challenge_sch.mdl file, in the examples folder.

---------------------------------------------------------------------------

USING THE ADAFRUIT MOTOR SHIELD:

The adafruit motor shield is a shield (with an associate library) 
to control dc and stepper motors. The Arduino IO package allows using the 
adafruit motor shield library primitives (in addition to the other basic 
IO and servo functions described above) directly from MATLAB.

Details on the shield are here, version 1: 
http://learn.adafruit.com/adafruit-motor-shield 
and version 2: 
http://learn.adafruit.com/adafruit-motor-shield-v2-for-arduino

Make sure you follow the instructions on installing the required library
(also see the "Installing the motor shield library" section above).

If you were using the adioes.pde sketch then you need to upload either
the motor_v1.pde (for versions 1.x of the shield) or motor_v2.pde (for 
the version 2 of the shield) sketch on the board, in order to use the motor 
shield related instructions. Both sketches NEED the related adafruit motor 
shield LIBRARY (see related installation step above) to work, regardless 
on whether the motor shield is mounted on top of the arduino or not.

Both motor sketches are the most comprehensive ones, that is you can use 
them also for basic I/O, servos, encoders and so on, even when the motor 
shield is not mounted on the arduino. However, note that the adafruit 
motor shield V1 uses a lot of the pins, (see the manual) so if you use both 
analog and digital IO and motor instructions they will likely INTERFERE 
WITH EACH OTHER, (especially for Version 1 of the library and shield). 
Therefore the best approach is using EITHER the IO instructions OR the 
motor shield instructions and delete and reinstantiate the arduino object 
everytime one needs to switch from one set of instructions to the other.

DO NOT HOT SWAP SHIELDS. Before mounting the motor shield delete the 
arduino object from the workspace, disconnect, then mount the motor shield
on top of the arduino, reconnect, upload motor.pde to the board, and
finally, from MATLAB, create a new arduino object.

ADAFRUIT MOTOR SHIELD EXAMPLE:

% connect the board
a=arduino('COM5')

% sets speed of motor 4 as 200/255
motorSpeed(a,4,200)      

% prints the speed of all motors
motorSpeed(a);    
        
% runs motor 1 forward
motorRun(a,4,'forward');    
 
% runs motor 3 backward
motorRun(a,4,'backward');     

% release motor 1
motorRun(a,4,'release');      

% sets speed of stepper 1 as 10 rpm
stepperSpeed(a,1,10)      

% prints the speed of stepper 1
stepperSpeed(a,1);         

% rotates stepper 1 forward of 100 steps in interleave mode 
stepperStep(a,1,'forward','double',100);

% rotates stepper 1 backward of 50 steps in single mode 
stepperStep(a,1,'backward','single',50); 

% releases stepper 1
stepperStep(a,1,'release'); 

% close session
delete(a)

Note that all the other functions related to pins analog and digital IO 
as well as to servos, can still be used as described in the previous 
example above.

Also note that the stepper instructions are blocking, that is the board
cannot start to execute a new instruction until the execution of the 
previous stepper command has come to completion (which might take several
seconds if the number of required steps is high).  

---------------------------------------------------------------------------

SIMULINK LIBRARY

Since version 3.0 this package also comes with a Simulink library that
has blocks for Analog and Digital IO, as well as Servo Read and Write, 
Motor, and Stepper control. Type "arduino_io_lib" to open the library.

The setup block can either use a pre existing arduino object in the 
workspace, or it can automatically instantiate a temporary arduino object 
before the simulation. In the latter case the object gets automatically 
deleted after the simulation is over. You have to use this block (the 
setup block) in order to use the other ones, and you have to use a 
different setup block for each different arduino variable that you use
in the simulation.

Examples that illustrate how to use analog IO blocks are the files 
"blink_challenge_sim.mdl" and "blink_challenge_sf.mdl", which are the
simulink and stateflow implementation of the blink challenge demo 
described above in this readme file. The file "servo_sim.mdl" shows
how to use the Servo Read and Write blocks.

Note that these blocks, being based on MATLAB objects (and relying on the 
OS serial communication stack), DO NOT SUPPORT CODE GENERATION. 
The Simulink Support Package for Arduino: 
http://www.mathworks.com/academia/arduino-software/arduino-simulink.html
and the Embedded Coder Support Package for Arduino:
http://www.mathworks.com/matlabcentral/fileexchange/30277
can both be used to automatically generate, from Simulink, arduino 
executables that are automatically uploaded and executed on the board.

---------------------------------------------------------------------------

TROUBLESHOOTING

This software was developed mainly on R2011a, and was not fully tested for
versions prior to R2010a, so i suggest to get at least R2011a (or later) 
if you can. 

The simulink library will NOT work on versions prior to R2010a, (because
the arduino object is shared among the blocks in the model using features
introduced from R2010a). In any case, this software uses the new MATLAB 
object system, and it definitely cannot work on versions prior to R2008a.

I have come across in the past to cases (using the Duemilanove board) in 
which MATLAB had problems in connecting to the arduino when creating an 
object (specifically, this resulted in the error message: "Connection 
unsuccessful, please make sure that the Arduino is powered on ... "),
even though i could connect fine with the IDE or Hyperterminal.

I believe this is solved now, as it was likely due to a combination of 
factors including the older servotimer library, too much time wasted in the
setup to initialize pins, and too low a delay between an attempted connection 
and the first operation. Anyway, if you happen to have a similar problem 
the first suggestion is to go into the arduino.m file, find these lines:

                fprintf(1,'Attempting connection .');
                for i=1:12,
                    pause(1);
                    fprintf(1,'.');
                end

and increase that 12 up to 15 or more until it works. Another suggestion 
is using the simpler adio.pde or adioe.pde sketches instead of the 
more complex adioes.pde or motor_vX.pde.

I had a few instances in which the above error showed up when the motor_v2
sketch was running on the Arduino Uno and a prototyping board with the 
blink challenge circuit was plugged on top of the Arduino Uno. Removing 
that specific board (and/or plugging the motor shield one), seemed to solve
that problem (i haven't been able to reproduce this with the Mega board).

Also, if you get an error like the following ones:

??? Error using ==> serial.fwrite at ...

or:

??? Error using ==> serial.get at ...
Instrument object OBJ is an invalid object.

or, during an object creation, like this:

??? Error using ==> arduino>arduino.arduino at 77
Could not open port: COM9 

or:

??? Error using ==> arduino>arduino.arduino at 48
Port COM9 already used by MATLAB

then it likely means that something went wrong with your serial connection,
(this might happen sometimes for example if the board resets itself, which
happens a lot when using the servos without a good power source) and your 
best chance is doing the following:

1) make sure no other program (e.g. the IDE is using the same COM port)
2) delete the arduino object, ignore possible warnings
3) delete(instrfind({'Port'},{'COM9'})) % of course use the right COM port
4) disconnect the arduino cable, then reconnect it
5) create a new arduino object

---------------------------------------------------------------------------

USING THE PACKAGE WITHOUT MATLAB (E.G. IDE or HYPETERMINAL)

Note that while this package was designed to be used with MATLAB, it can
be used with any program that allows you to communicate via serial port.

This is actually a good troubleshooting strategy, as it allows you to 
discover whether any problem or unexpected behavior originates at the
hardware or operating system level, or whether it originates in MATLAB.

The easier way of doing this is using the IDE Serial Monitor (in the upper 
right corner of the IDE) to send messages and receive results. Once you
start the serial monitor and select 115200 as baud rate, you can you type 
messages in the upper row and send them via serial port clicking the Send 
button. 

A serial message to adioes.pde is typically made up by no more than 3 parts:
1) a number or uppercase letter indicating the action
2) a lowercase letter indicating the pin number
3) a number or letter indicating a value to be transmitted

For example the command "1c" reads digital pin #2, as "1" stands for 
digitalRead and "c" stands for pin #2 (ascii(c)-ascii(a)=2) 

Similarly (reported from motor.pde):

   0e0   : assigns digital pin #4 (e) as input
   0f1   : assigns digital pin #5 (f) as output
   0n1   : assigns digital pin #13 (n) as output   
   
   1c    : reads digital pin #2 (c) 
   1e    : reads digital pin #4 (e) 
   2n0   : sets digital pin #13 (n) low
   2n1   : sets digital pin #13 (n) high
   2f1   : sets digital pin #5 (f) high
   2f0   : sets digital pin #5 (f) low
   4j2   : sets digital pin #9 (j) to  50=ascii(2) over 255
   4jz   : sets digital pin #9 (j) to 122=ascii(z) over 255
   3a    : reads analog pin #0 (a) 
   3f    : reads analog pin #5 (f) 

   5j    : reads status (attached/detached) of servo on pin #9
   5k    : reads status (attached/detached) of servo on pin #10
   6j1   : attaches servo on pin #9
   8jz   : moves servo on pin #9 of 122 degrees (122=ascii(z))
   7j    : reads angle of servo on pin #9
   6j0   : detaches servo on pin #9

   A1z   : sets speed of motor #1 to 122 over 255  (122=ascii(z))
   A4A   : sets speed of motor #4 to 65 over 255 (65=ascii(A))
   B1f   : runs motor #1 forward (f=forward)
   B4b   : runs motor #4 backward (b=backward)
   B1r   : releases motor #1 (r=release)

   C12   : sets speed of stepper motor #1 to 50 rpm  (50=ascii(2))
   C2Z   : sets speed of stepper motor #2 to 90 rpm  (90=ascii(Z))
   D1fsz : do 122 steps on motor #1 forward in single (s) mode 
   D1biA : does 65 steps on motor #1 backward in interleave (i) mode 
   D2fdz : does 122 steps on motor #1 forward in double (d) mode 
   D2bmA : does 65 steps on motor #2 backward in microstep (m) mode 
   D1r   : releases motor #1 (r=release)
   D2r   : releases motor #2 (r=release)

   E0cd  : attaches encoder #0 (0) on pins 2 (c) and 3 (d)
   E1st  : attaches encoder #1 on pins 18 (s) and 19 (t)
   E2vu  : attaches encoder #2 on pins 21 (v) and 20 (u)
   G0    : gets 0 position of encoder #0
   I0u   : sets debounce delay to 20 (2ms) for encoder #0
   H1    : resets position of encoder #1
   F2    : detaches encoder #2
   
   R0    : sets analog reference to DEFAULT
   R1    : sets analog reference to INTERNAL
   R2    : sets analog reference to EXTERNAL
  
   X3    : roundtrip example case returning the input (ascii(3)) 
   99    : returns script type (0 adio.pde ... 3 motor.pde )

In general, it is expected that if any of the 4 server sketches was 
successfully compiled and uploaded to the board then one should be able 
to communicate with the board via serial port as described above.

On Windows platforms prior to vista , you can open hyperterminal, 
(Start -> Programs -> Accessories -> Communications -> HyperTerminal)
select the right com port in the initial "connect to" dialog, then select 
115200 as "Bits per second", and also select "None" as flow control.
You cannot see what you type, but you should be see the results, so typing
"99" should return the sript type (1,2 or 3) right away. This gives a way
to test the package in an IDE-independent way, which might also be important
in troubleshooting a problem.

---------------------------------------------------------------------------

CUSTOMIZATION:

For people wanting to customize the package or simply add their own code
to do stuff, it is suggested to start from the roundTrip function mentioned
above, which is specifically provided as an example for this purposes.
The section handling this dummy function in the pde file is located starting
from "case 400:", one might take the parameter, perform some potentially 
useful operation, and then send any result back via serial connection.

---------------------------------------------------------------------------

FILES & HISTORY:

See contents.m for details on files and version history.

---------------------------------------------------------------------------

Giampiero Campa, August 2013, Copyright 2013 The MathWorks, Inc.