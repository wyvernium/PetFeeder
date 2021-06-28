
int suKabi = 0 ; // okuma yapacağımız analog deger değişkeni
int sensorAnalogPin = A0;
String data;

void setup() {
  // put your setup code here, to run once:
  Serial.begin(115200);

}

void loop() {
  // put your main code here, to run repeatedly:
  suKabi = analogRead(sensorAnalogPin);
  Serial.print("<<<");
  Serial.print(suKabi);
  Serial.println(">>>");
}
