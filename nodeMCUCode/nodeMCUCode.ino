ygulam#include<ESP8266WiFi.h>
#include<FirebaseArduino.h>
#include<FirebaseHttpClient.h>

#define FIREBASE_HOST "su-kabi-default-rtdb.firebaseio.com"
#define FIREBASE_AUTH "AchCCiVGArnb4xDreWrE9Jguic2tR0EXbJyBIxBR"

//for wifi setup
#define WIFI_SSID "your wifi ssid is here"
#define WIFI_PASSWORD "your wifi password is here"


int sensorBowl = A0;
int motorPin = 5;
int buttonPin = 4;
int bowlLevel=0;
int storageLevel=0;
bool switchStatus=false;
bool buttonStatus=false;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(9600);
  WiFi.disconnect();

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.println("connecting...");

  while(WiFi.status() != WL_CONNECTED){
    delay(50);
    Serial.print(".");
    }
  Serial.println("");
  Serial.print("connected to :");
  Serial.println(WiFi.localIP());

  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);

  Firebase.setInt("Data/Storage:", storageLevel);
  Firebase.setInt("Data/Bowl:", bowlLevel);
  Firebase.setBool("Board/button", buttonStatus);
  switchStatus = Firebase.getBool("Motor/switch");
  Firebase.setString("Data/pump", "Pump isn't working");

  pinMode(sensorBowl, INPUT);
  pinMode(buttonPin,INPUT);
  pinMode(motorPin,OUTPUT);
  digitalWrite(motorPin,false);
  
}

void loop() {
  // put your main code here, to run repeatedly:
  bowlLevel = analogRead(sensorBowl);
  int percentBowl = map(bowlLevel, 0,1023,0,100);
  Firebase.setInt("Data/Bowl:",percentBowl);
  storageLevel = Serial.parseInt();
  int percentStorage = map(storageLevel, 0,1023,0,100);
  Firebase.setInt("Data/Storage:", percentStorage);
  buttonStatus = bool(digitalRead(buttonPin));
  Firebase.setBool("Board/button",buttonStatus);
  switchStatus = bool(Firebase.getBool("Motor/switch"));
  if( switchStatus==true || buttonStatus==true){
    if( percentBowl <= 80 && percentStorage > 0){
      Firebase.setString("Data/pump", "Pump is working");
      digitalWrite(motorPin,true);
      }
    else {
      Firebase.setString("Data/pump", "Pump isn't working");
      digitalWrite(motorPin, false);
      }
    }
  else{
    Firebase.setString("Data/pump", "Pump isn't working");
    digitalWrite(motorPin, false);
    }
}
