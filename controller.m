#include "mbed.h"
#include "physcom.h"
using namespace physcom;
DigitalOut redled_person (p20); //redlight pedastrian
DigitalOut greenled_person (p19);//greenlight pedastrian
DigitalOut redled_car (p17);//redlight car
DigitalOut greenled_car(p16);//greenlight car
Serial pc(USBTX, USBRX); //open a serial communication channel
void set_LED_car (char * input, char * output);
RPCFunction set_LED_car_mbed (&set_LED, "set_LED_car_mbed");
void set_LED_pedestrian (char * input, char * output);
RPCFunction set_LED_pedestrian_mbed (&set_LED,
"set_LED_pedestrian_mbed");
//declare it as RPC
//receive commands, and send back the responses
char input[RPC_MAX_STRING], output[RPC_MAX_STRING];
// Callback executed whenever there is new input on the serial
connection
void RPCSerial() {
pc.gets(input, RPC_MAX_STRING);
RPC::call(input, output);
pc.printf("%s\n", output);
}
int main() {
// Attaching the callback to the Serial interface
// RPCSerial() will be executed whenever a serial interrupt is generated
pc.attach(&RPCSerial, Serial::RxIrq);
while (1){
}
}
void set_LED_car (char * input, char * output){
if (input == '1'){ //if car is seen, car lights go green
greenled_person = 0;
redled_person = 1;
greenled_car = 1;
redled_car = 0;
wait(5); //time for car to pass
}
greenled_person = 0; //all lights go red
redled_person = 1;
greenled_car = 0;
redled_car = 1;
}
void set_LED_pedestrian (char * input, char * output){
if (input == '1'){ //if pedestrian is seen, pedestrian lights go
green
greenled_person = 1;
redled_person = 0;
greenled_car = 0;
redled_car = 1;
wait(5); //time for pedestrian to pass
}
Classification code:
Training network code:
greenled_person = 0; //all lights go red
redled_person = 1;
greenled_car = 0;
redled_car = 1;
}