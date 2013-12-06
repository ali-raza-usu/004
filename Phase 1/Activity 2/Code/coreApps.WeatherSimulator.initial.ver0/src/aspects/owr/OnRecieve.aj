package aspects.owr;

import java.awt.image.RescaleOp;
import java.util.ArrayList;
import java.util.List;

import joinpoints.communication.ReceiveEventJP;
import baseaspects.communication.OneWayReceiveAspect;
import utilities.Encoder;
import utilities.Message;
import org.apache.log4j.Logger;

import utilities.messages.ver0.WeatherDataVector;
import utilities.messages.ver1.WeatherDataReading;
import utilities.messages.ver1.WeatherDataVector.LocType;


public aspect OnRecieve extends OneWayReceiveAspect{
	private Logger logger = Logger.getLogger(OnRecieve.class);
	
	after (ReceiveEventJP _receiveEventJp):  ConversationEnd(_receiveEventJp){ 
	{
		Message msg =  (Message)Encoder.decode(_receiveEventJp.getBytes());
		String logString = "OneWayReceiver: Receiver: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " ID = " +_receiveEventJp.getConversation().getId().toString();
 	if(getTargetClass().equals("Receiver"))
 	{
 		if(msg.getClass().getSimpleName().equals(utilities.messages.ver0.WeatherDataRequest.class.getSimpleName()))
 		{
 			utilities.messages.ver1.WeatherDataRequest requestV1=(utilities.messages.ver1.WeatherDataRequest) msg;
 			utilities.messages.ver0.WeatherDataRequest requestV0= new utilities.messages.ver0.WeatherDataRequest();
 			msg  = requestV0;
 		}
 	}
 	else if(getTargetClass().equals("Transmitter_8815"))
 	{
 		if(msg.getClass().getSimpleName().equals(WeatherDataVector.class.getSimpleName()))
 		{
 			utilities.messages.ver0.WeatherDataVector requestV0=(utilities.messages.ver0.WeatherDataVector) msg;
 			msg=changeToV1(requestV0);
 		}
 	}
 	_receiveEventJp.setBytes(Encoder.encode(msg));
 	logString+= "\n"+msg.getClass().getSimpleName()+ "Message Version=" + msg.getVersion().toString();
 	logger.debug(logString);		
	System.out.println(logString);
	}
	}

public static String getTargetClass() {
	StackTraceElement[] elements = Thread.currentThread().getStackTrace();
	String[] classes = elements[elements.length - 1].getClassName().split("\\.");
	return classes[classes.length - 1];
}

public Message changeToV1(WeatherDataVector data){
	Message masg=new Message();
	
	 List<utilities.messages.ver0.WeatherDataReading> weatherDataV0=data.getReadings();
	 List<utilities.messages.ver1.WeatherDataReading> weatherDataV1=new  ArrayList<WeatherDataReading>();
	 for(utilities.messages.ver0.WeatherDataReading w: weatherDataV0)
	 {
		LocType loctype=utilities.messages.ver1.WeatherDataVector.LocType.values()[w.getFacilityLocType().ordinal()];
		
		//System.out.println(w.getFacilityLocType().ordinal());
		
		utilities.messages.ver1.WeatherDataVector.ObservationType type=
				utilities.messages.ver1.WeatherDataVector.ObservationType.values()[w.getFacilityLocType().ordinal()];
		
		 utilities.messages.ver1.WeatherDataReading readData=new  utilities.messages.ver1.WeatherDataReading(w.getSpeed(), 
				 w.getWindDirection(), w.getHumidity(), w.getPrecipitation(), loctype, w.getPressure(), w.getCloudHeight(), 
				 w.getVisibility(), w.getSolarRadiations(), w.getSnowDepth(), type, w.getTemperature(), w.getSendTime(),
				 w.getSize(), w.getResolution());
		 weatherDataV1.add(readData);
	 }
	 utilities.messages.ver1.WeatherDataVector requestV1=new utilities.messages.ver1.WeatherDataVector(weatherDataV1);
	 masg=requestV1;
	return masg;
}
}
