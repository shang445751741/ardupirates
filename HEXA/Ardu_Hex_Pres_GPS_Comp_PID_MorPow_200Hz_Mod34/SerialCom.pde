/*
 ArduCopter v1.3 - August 2010
 www.ArduCopter.com
 Copyright (c) 2010.  All rights reserved.
 An Open Source Arduino based multicopter.
 
 This program is free software: you can redistribute it and/or modify 
 it under the terms of the GNU General Public License as published by 
 the Free Software Foundation, either version 3 of the License, or 
 (at your option) any later version. 
 
 This program is distributed in the hope that it will be useful, 
 but WITHOUT ANY WARRANTY; without even the implied warranty of 
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the 
 GNU General Public License for more details. 
 
 You should have received a copy of the GNU General Public License 
 along with this program. If not, see <http://www.gnu.org/licenses/>.
*/

void readSerialCommand() {
  // Check for serial message
  if (SerAva()) {
    queryType = SerRea();
    switch (queryType) {
    case 'A': // Stable PID
      KP_QUAD_ROLL = readFloatSerial();
      KI_QUAD_ROLL = readFloatSerial();
      STABLE_MODE_KP_RATE_ROLL = readFloatSerial();
      KP_QUAD_PITCH = readFloatSerial();
      KI_QUAD_PITCH = readFloatSerial();
      STABLE_MODE_KP_RATE_PITCH = readFloatSerial();
      KP_QUAD_YAW = readFloatSerial();
      KI_QUAD_YAW = readFloatSerial();
      STABLE_MODE_KP_RATE_YAW = readFloatSerial();
      STABLE_MODE_KP_RATE = readFloatSerial();   // NOT USED NOW
      MAGNETOMETER = readFloatSerial();
      break;
    case 'C': // Receive GPS PID
      KP_GPS_ROLL = readFloatSerial();
      KI_GPS_ROLL = readFloatSerial();
      KD_GPS_ROLL = readFloatSerial();
      KP_GPS_PITCH = readFloatSerial();
      KI_GPS_PITCH = readFloatSerial();
      KD_GPS_PITCH = readFloatSerial();
      GPS_MAX_ANGLE = readFloatSerial();
      GEOG_CORRECTION_FACTOR = readFloatSerial();
      break;
    case 'E': // Receive altitude PID
      KP_ALTITUDE = readFloatSerial();
      KI_ALTITUDE = readFloatSerial();
      KD_ALTITUDE = readFloatSerial();
      break;
    case 'G': // Receive drift correction PID
      Kp_ROLLPITCH = readFloatSerial();
      Ki_ROLLPITCH = readFloatSerial();
      Kp_YAW = readFloatSerial();
      Ki_YAW = readFloatSerial();
      break;
    case 'I': // Receive sensor offset
      gyro_offset_roll = readFloatSerial();
      gyro_offset_pitch = readFloatSerial();
      gyro_offset_yaw = readFloatSerial();
      acc_offset_x = readFloatSerial();
      acc_offset_y = readFloatSerial();
      acc_offset_z = readFloatSerial();
      break;
    case 'K': // Spare
      break;
    case 'M': // Receive debug motor commands
      LeftCWMotor = readFloatSerial();
      LeftCCWMotor = readFloatSerial();
      RightCWMotor = readFloatSerial();
      RightCCWMotor = readFloatSerial();
//      BackCWMotor = readFloatSerial();
//      BackCCWMotor = readFloatSerial();
      motorArmed = readFloatSerial();
      break;
    case 'O': // Rate Control PID
      Kp_RateRoll = readFloatSerial();
      Ki_RateRoll = readFloatSerial();
      Kd_RateRoll = readFloatSerial();
      Kp_RatePitch = readFloatSerial();
      Ki_RatePitch = readFloatSerial();
      Kd_RatePitch = readFloatSerial();
      Kp_RateYaw = readFloatSerial();
      Ki_RateYaw = readFloatSerial();
      Kd_RateYaw = readFloatSerial();
      xmitFactor = readFloatSerial();
      break;
    case 'W': // Write all user configurable values to EEPROM
      writeUserConfig();
      break;
    case 'Y': // Initialize EEPROM with default values
      defaultUserConfig();
      break;
    case '1': // Receive transmitter calibration values
      ch_roll_slope = readFloatSerial();
      ch_roll_offset = readFloatSerial();
      ch_pitch_slope = readFloatSerial();
      ch_pitch_offset = readFloatSerial();
      ch_yaw_slope = readFloatSerial();
      ch_yaw_offset = readFloatSerial();
      ch_throttle_slope = readFloatSerial();
      ch_throttle_offset = readFloatSerial();
      ch_gear_slope = readFloatSerial();
      ch_gear_offset = readFloatSerial();
      ch_aux2_slope = readFloatSerial();
      ch_aux2_offset = readFloatSerial();
    break;
    }
  }
}

void sendSerialTelemetry() {
  float aux_float[3]; // used for sensor calibration
  switch (queryType) {
  case '=': // Reserved debug command to view any variable from Serial Monitor
/*    SerPri("throttle =");
    SerPriln(ch_throttle);
    SerPri("control roll =");
    SerPriln(control_roll-CHANN_CENTER);
    SerPri("control pitch =");
    SerPriln(control_pitch-CHANN_CENTER);
    SerPri("control yaw =");
    SerPriln(control_yaw-CHANN_CENTER);
    SerPri("front left yaw =");
    SerPriln(frontMotor);
    SerPri("front right yaw =");
    SerPriln(rightMotor);
    SerPri("rear left yaw =");
    SerPriln(leftMotor);
    SerPri("rear right motor =");
    SerPriln(backMotor);
    SerPriln();

    SerPri("current roll rate =");
    SerPriln(read_adc(0));
    SerPri("current pitch rate =");
    SerPriln(read_adc(1));
    SerPri("current yaw rate =");
    SerPriln(read_adc(2));
    SerPri("command rx yaw =");
    SerPriln(command_rx_yaw);
    SerPriln(); 
    queryType = 'X';*/
    SerPri(APM_RC.InputCh(0));
    comma();
    SerPri(ch_roll_slope);
    comma();
    SerPri(ch_roll_offset);
    comma();
    SerPriln(ch_roll);
    break;
  case 'B': // Send roll, pitch and yaw PID values
    SerPri(KP_QUAD_ROLL, 3);
    comma();
    SerPri(KI_QUAD_ROLL, 3);
    comma();
    SerPri(STABLE_MODE_KP_RATE_ROLL, 3);
    comma();
    SerPri(KP_QUAD_PITCH, 3);
    comma();
    SerPri(KI_QUAD_PITCH, 3);
    comma();
    SerPri(STABLE_MODE_KP_RATE_PITCH, 3);
    comma();
    SerPri(KP_QUAD_YAW, 3);
    comma();
    SerPri(KI_QUAD_YAW, 3);
    comma();
    SerPri(STABLE_MODE_KP_RATE_YAW, 3);
    comma();
    SerPri(STABLE_MODE_KP_RATE, 3);    // NOT USED NOW
    comma();
    SerPriln(MAGNETOMETER, 3);
    queryType = 'X';
    break;
  case 'D': // Send GPS PID
    SerPri(KP_GPS_ROLL, 3);
    comma();
    SerPri(KI_GPS_ROLL, 3);
    comma();
    SerPri(KD_GPS_ROLL, 3);
    comma();
    SerPri(KP_GPS_PITCH, 3);
    comma();
    SerPri(KI_GPS_PITCH, 3);
    comma();
    SerPri(KD_GPS_PITCH, 3);
    comma();
    SerPri(GPS_MAX_ANGLE, 3);
    comma();
    SerPriln(GEOG_CORRECTION_FACTOR, 3);
    queryType = 'X';
    break;
  case 'F': // Send altitude PID
    SerPri(KP_ALTITUDE, 3);
    comma();
    SerPri(KI_ALTITUDE, 3);
    comma();
    SerPriln(KD_ALTITUDE, 3);
    queryType = 'X';
    break;
  case 'H': // Send drift correction PID
    SerPri(Kp_ROLLPITCH, 4);
    comma();
    SerPri(Ki_ROLLPITCH, 7);
    comma();
    SerPri(Kp_YAW, 4);
    comma();
    SerPriln(Ki_YAW, 6);
    queryType = 'X';
    break;
  case 'J': // Send sensor offset
    SerPri(gyro_offset_roll);
    comma();
    SerPri(gyro_offset_pitch);
    comma();
    SerPri(gyro_offset_yaw);
    comma();
    SerPri(acc_offset_x);
    comma();
    SerPri(acc_offset_y);
    comma();
    SerPriln(acc_offset_z);
    AN_OFFSET[3] = acc_offset_x;
    AN_OFFSET[4] = acc_offset_y;
    AN_OFFSET[5] = acc_offset_z;
    queryType = 'X';
    break;
  case 'L': // Spare
    RadioCalibration();
    queryType = 'X';
    break;
  case 'N': // Send magnetometer config
    queryType = 'X';
    break;
  case 'P': // Send rate control PID
    SerPri(Kp_RateRoll, 3);
    comma();
    SerPri(Ki_RateRoll, 3);
    comma();
    SerPri(Kd_RateRoll, 3);
    comma();
    SerPri(Kp_RatePitch, 3);
    comma();
    SerPri(Ki_RatePitch, 3);
    comma();
    SerPri(Kd_RatePitch, 3);
    comma();
    SerPri(Kp_RateYaw, 3);
    comma();
    SerPri(Ki_RateYaw, 3);
    comma();
    SerPri(Kd_RateYaw, 3);
    comma();
    SerPriln(xmitFactor, 3);
    queryType = 'X';
    break;
  case 'Q': // Send sensor data
    SerPri(read_adc(0));
    comma();
    SerPri(read_adc(1));
    comma();
    SerPri(read_adc(2));
    comma();
    SerPri(read_adc(4));
    comma();
    SerPri(read_adc(3));
    comma();
    SerPri(read_adc(5));
    comma();
    SerPri(err_roll);
    comma();
    SerPri(err_pitch);
    comma();
    SerPri(degrees(roll));
    comma();
    SerPri(degrees(pitch));
    comma();
    SerPriln(degrees(yaw));
    break;
  case 'R': // Send raw sensor data
    break;
  case 'S': // Send all flight data
    SerPri(timer-timer_old);
    comma();
    SerPri(read_adc(0));
    comma();
    SerPri(read_adc(1));
    comma();
    SerPri(read_adc(2));
    comma();
    SerPri(ch_throttle);
    comma();
    SerPri(control_roll);
    comma();
    SerPri(control_pitch);
    comma();
    SerPri(control_yaw);
    comma();
    SerPri(LeftCWMotor); // Left Top Motor
    comma();
    SerPri(LeftCCWMotor); // Left Bottom Motor
    comma();
    SerPri(RightCWMotor); // Right Top Motor
    comma();
    SerPri(RightCCWMotor); // Right Bottom Motor
    comma();
//    SerPri(BackCWMotor); // Back Top Motor
//    comma();
//    SerPri(BackCCWMotor); // Back Bottom Motor
//    comma();
    SerPri(read_adc(4));
    comma();
    SerPri(read_adc(3));
    comma();
    SerPriln(read_adc(5));
    break;
  case 'T': // Spare
    SerPri("AP Mode = ");
    if (AP_mode == 0) 
      SerPriln("Acrobatic");
    else if (AP_mode == 1)
      SerPriln("Position Hold");
    else if (AP_mode == 2)
      SerPriln("Stable Mode");
    else if (AP_mode == 3)
      SerPriln("Position & Altitude Hold");
    SerPri("BMP Mode = ");
    if (BMP_mode == 0) {
      SerPriln("Off");
    } else {
      SerPriln("On");
    } 
    SerPri("Target Altitude = ");
    SerPriln(BMP_target_altitude);
    SerPri("Current Altitude = ");
    SerPriln(BMP_Altitude);
//    SerPri("throttle_command = ");
//    SerPriln(ch_throttle);
//    SerPri("Yaw mid = ");
//    SerPriln(yaw_mid);
//    SerPri("BMP_altitude command = ");
//    SerPriln(BMP_command_altitude);
//    SerPri("Amount RX Yaw = ");
//    SerPriln(amount_rx_yaw);
    SerPri("Current Compass Heading = ");
    current_heading_hold = APM_Compass.Heading;
    if (current_heading_hold < 0)
      current_heading_hold += ToRad(360);
    SerPriln(ToDeg(current_heading_hold), 3);
//    SerPri("Error Course = ");
//    SerPriln(ToDeg(errorCourse), 3);
    SerPri("Heading Hold Mode = ");
    if (heading_hold_mode == 0) 
      SerPriln("Off");
    else 
      SerPriln("On");
    
    SerPri("KP ALTITUDE = ");
    SerPriln(KP_ALTITUDE, 3);
    SerPri("EEPROM KP ALTITUDE = ");
    SerPriln(readEEPROM(KP_ALTITUDE_ADR), 3);
    SerPri("KI ALTITUDE = ");
    SerPriln(KI_ALTITUDE, 3);
    SerPri("EEPROM KI ALTITUDE = ");
    SerPriln(readEEPROM(KI_ALTITUDE_ADR), 3);
    SerPri("KD ALTITUDE = ");
    SerPriln(KD_ALTITUDE, 3);
    SerPri("EEPROM KD ALTITUDE = ");
    SerPriln(readEEPROM(KD_ALTITUDE_ADR), 3);
//    SerPri("KP ROLL ACRO MODE = ");
//    SerPriln(Kp_RateRoll, 3);
//    SerPri("EEPROM KP ROLL ACRO MODE = ");
//    SerPriln(readEEPROM(KP_RATEROLL_ADR), 3);
//    SerPri("STABLE MODE KP RATE ROLL = ");
//    SerPriln(STABLE_MODE_KP_RATE_ROLL, 3);
//    SerPri("EEPROM STABLE MODE KP RATE ROLL = ");
//    SerPriln(readEEPROM(STABLE_MODE_KP_RATE_ROLL_ADR), 3);
//    SerPri("STABLE MODE KP RATE PITCH = ");
//    SerPriln(STABLE_MODE_KP_RATE_PITCH, 3);
//    SerPri("EEPROM STABLE MODE KP RATE PITCH = ");
//    SerPriln(readEEPROM(STABLE_MODE_KP_RATE_PITCH_ADR), 3);
//    SerPri("KP PITCH ACRO MODE = ");
//    SerPriln(Kp_RatePitch, 3);
//    SerPri("EEPROM KP PITCH ACRO MODE = ");
//    SerPriln(readEEPROM(KP_RATEPITCH_ADR), 3);
//    SerPri("KP STABLE MODE YAW = ");
//    SerPriln(STABLE_MODE_KP_RATE_YAW, 3);
//    SerPri("EEPROM KP STABLE MODE YAW = ");
//    SerPriln(readEEPROM(STABLE_MODE_KP_RATE_YAW_ADR), 3);

//    SerPri("KP GPS Roll = ");
//    SerPriln(KP_GPS_ROLL, 3);
//    SerPri("KP GPS Pitch = ");
//    SerPriln(KP_GPS_PITCH, 3);
//    SerPri("EEPROM KP GPS ROLL = ");
//    SerPriln(readEEPROM(KP_GPS_ROLL_ADR), 3);
//    SerPri("EEPROM KP GPS PITCH = ");
//    SerPriln(readEEPROM(KP_GPS_ROLL_ADR), 3);
//    SerPri("KI GPS Roll = ");
//    SerPriln(KI_GPS_ROLL, 4);
//    SerPri("KI GPS Pitch = ");
//    SerPriln(KI_GPS_PITCH, 4);
//    SerPri("EEPROM KI GPS ROLL = ");
//    SerPriln(readEEPROM(KI_GPS_ROLL_ADR), 4);
//    SerPri("EEPROM KP GPS PITCH = ");
//    SerPriln(readEEPROM(KI_GPS_ROLL_ADR), 4);
//    SerPri("Magnetometer = ");
//    SerPriln(MAGNETOMETER);
//    SerPri("EEPROM Magnetometer = ");
//    SerPriln(readEEPROM(MAGNETOMETER_ADR));
//    SerPri("Magnetometer Offset= ");
//    SerPriln(Magoffset);
//    SerPri("EEPROM Magoffset = ");
//    SerPriln(readEEPROM(Magoffset_ADR));
    
//    SerPri("Yaw = ");
//    SerPriln(yaw);
//    SerPri("Yaw to Degree = ");
//    SerPriln(ToDeg(yaw));
//    SerPri("command rx yaw =");
//    SerPriln(command_rx_yaw);

    SerPriln(); 
    queryType = 'X';
     break;
  case 'U': // Send receiver values
    SerPri(ch_roll); // Aileron
    comma();
    SerPri(ch_pitch); // Elevator
    comma();
    SerPri(ch_yaw); // Yaw
    comma();
    SerPri(ch_throttle); // Throttle
    comma();
    SerPri(ch_gear); // GEAR Channel on Radio 
    comma();
    SerPri(ch_aux2); // AUX2 
    comma();
    SerPri(roll_mid); // Roll MID value
    comma();
    SerPri(pitch_mid); // Pitch MID value
    comma();
    SerPriln(yaw_mid); // Yaw MID Value
    break;
  case 'V': // Spare
    break;
  case 'X': // Stop sending messages
    break;
  case '!': // Send flight software version
    SerPriln(VER);
    queryType = 'X';
    break;
  case '2': // Send transmitter calibration values
    SerPri(ch_roll_slope);
    comma();
    SerPri(ch_roll_offset);
    comma();
    SerPri(ch_pitch_slope);
    comma();
    SerPri(ch_pitch_offset);
    comma();
    SerPri(ch_yaw_slope);
    comma();
    SerPri(ch_yaw_offset);
    comma();
    SerPri(ch_throttle_slope);
    comma();
    SerPri(ch_throttle_offset);
    comma();
    SerPri(ch_gear_slope);
    comma();
    SerPri(ch_gear_offset);
    comma();
    SerPri(ch_aux2_slope);
    comma();
    SerPriln(ch_aux2_offset);
    queryType = 'X';
  break;
  case '.': // Modify GPS settings
    Serial1.print("$PGCMD,16,0,0,0,0,0*6A\r\n");
    break;
  }
}

// Used to read floating point values from the serial port
float readFloatSerial() {
  byte index = 0;
  byte timeout = 0;
  char data[128] = "";

  do {
    if (SerAva() == 0) {
      delay(10);
      timeout++;
    }
    else {
      data[index] = SerRea();
      timeout = 0;
      index++;
    }
  }  
  while ((data[constrain(index-1, 0, 128)] != ';') && (timeout < 5) && (index < 128));
  return atof(data);
}
