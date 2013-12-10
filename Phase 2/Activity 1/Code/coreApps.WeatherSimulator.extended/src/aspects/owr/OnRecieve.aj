package aspects.owr;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import simulation.communication.*;
import utilities.messages.ver0.*;
import joinpoints.communication.ReceiveEventJP;
import utilities.MessageVersion;
import baseaspects.communication.OneWayReceiveAspect;
import utilities.Encoder;
import org.apache.log4j.Logger;


public aspect OnRecieve extends OneWayReceiveAspect
{
	private Logger logger = Logger.getLogger(OnRecieve.class);
	after (ReceiveEventJP _receiveEventJp):  ConversationEnd(_receiveEventJp)
	{
		
		MessageVersion msg =  (MessageVersion)Encoder.decode(_receiveEventJp.getBytes());
		String logString = "OneWayReceiver: Receiver: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " ID = " +_receiveEventJp.getConversation().getId().toString();
		
		if(msg != null)
		{
			System.out.println("debug : message type is "+ msg.getClass());
			if(msg.getClass().getSimpleName().equals(utilities.messages.ver0.WeatherDataRequest.class.getSimpleName()))
	 		{
	 			msg = changeVersion(msg);
	 		}
			System.out.println("debug : before entrering Weather data vector");
	 
			if(msg.getClass().getSimpleName().equals(WeatherDataVector.class.getSimpleName()))
			{
				System.out.println("debug : inside Weather data vector");
				msg = changeVersion(msg);
	 		}
	 	}
	 	_receiveEventJp.setBytes(Encoder.encode(msg));
	 	logString+= "\n"+msg.getClass().getSimpleName()+ "Message Version=" + msg.getVersion().toString();
	 	logger.debug(logString);		
		System.out.println(logString);
	}
	public MessageVersion changeVersion(MessageVersion msg) 
	{
		System.out.println("debug : MessageVersion  target classs" + getTargetClass() + " receiver msg version "+ msg.getVersion() + "  getReceiver_version "+ (msg.getReceiver_version()));
		if((!msg.getVersion().equals(msg.getReceiver_version())) && 
				(getTargetClass().equals(Transmitter_8815.class.getSimpleName())|| 
						(getTargetClass().equals(Transmitter_8816.class.getSimpleName()))))
		{// server
			
			System.out.println("debug : from receiver " + getTargetClass());
			if(msg.getClass().getSimpleName().equals(WeatherDataRequest.class.getSimpleName())){
				utilities.messages.ver1.WeatherDataRequest requestV1=(utilities.messages.ver1.WeatherDataRequest) msg;
				utilities.messages.ver0.WeatherDataRequest requestV0= new utilities.messages.ver0.WeatherDataRequest(requestV1.getReqType());
				msg  = requestV0;
			}
			else if(msg.getClass().getSimpleName().equals(WeatherDataVector.class.getSimpleName())){
 				utilities.messages.ver1.WeatherDataVector requestV1=(utilities.messages.ver1.WeatherDataVector) msg;
 				msg=(MessageVersion) changeToV0(requestV1);
			}
		}
		else if((!msg.getVersion().equals(msg.getReceiver_version())) && 
				(getTargetClass().equals(Receiver.class.getSimpleName())))
		{// client
			
			System.out.println("debug : from receiver " + getTargetClass());
			if(msg.getClass().getSimpleName().equals(WeatherDataRequest.class.getSimpleName())){
				utilities.messages.ver0.WeatherDataRequest requestV0=(utilities.messages.ver0.WeatherDataRequest) msg;
				utilities.messages.ver1.WeatherDataRequest requestV1= new utilities.messages.ver1.WeatherDataRequest(requestV0.getReqType());
				msg  = requestV1;
			}
			if(msg.getClass().getSimpleName().equals(WeatherDataVector.class.getSimpleName())){
 				utilities.messages.ver0.WeatherDataVector requestV0=(utilities.messages.ver0.WeatherDataVector) msg;
 				msg=(MessageVersion) changeToV1(requestV0);
			}
		}
		
		return msg;
	}
public static String getTargetClass() {
	StackTraceElement[] elements = Thread.currentThread().getStackTrace();
	String[] classes = elements[elements.length - 1].getClassName().split("\\.");
	return classes[classes.length - 1];
}

public MessageVersion changeToV1(WeatherDataVector data){
	MessageVersion masg=new MessageVersion();
	
	 List<utilities.messages.ver0.WeatherDataReading> weatherDataV0=data.getReadings();
	 List<utilities.messages.ver1.WeatherDataReading> weatherDataV1=new  ArrayList<utilities.messages.ver1.WeatherDataReading>();
	 for(utilities.messages.ver0.WeatherDataReading w: weatherDataV0)
	 {
		 utilities.messages.ver1.WeatherDataVector.LocType loctype=utilities.messages.ver1.WeatherDataVector.LocType.values()[w.getFacilityLocType().ordinal()];
		
		System.out.println(w.getFacilityLocType().ordinal());
		
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

public MessageVersion changeToV0(utilities.messages.ver1.WeatherDataVector data){
	MessageVersion masg=new MessageVersion();
	
	 List<utilities.messages.ver1.WeatherDataReading> weatherDataV1=data.getReadings();
	 List<utilities.messages.ver0.WeatherDataReading> weatherDataV0=new ArrayList<utilities.messages.ver0.WeatherDataReading>();
	 for(utilities.messages.ver1.WeatherDataReading w: weatherDataV1)
	 {
		 utilities.messages.ver0.WeatherDataVector.LocType loctype=utilities.messages.ver0.WeatherDataVector.LocType.values()[w.getFacilityLocType().ordinal()];
		
		System.out.println(w.getFacilityLocType().ordinal());
		
		utilities.messages.ver0.WeatherDataVector.ObservationType type=
				utilities.messages.ver0.WeatherDataVector.ObservationType.values()[w.getFacilityLocType().ordinal()];
		
		 utilities.messages.ver0.WeatherDataReading readData=new  utilities.messages.ver0.WeatherDataReading(w.getSpeed(), 
				 w.getWindDirection(), w.getHumidity(), w.getPrecipitation(), loctype, w.getPressure(), w.getCloudHeight(), 
				 w.getVisibility(), w.getSolarRadiations(), w.getSnowDepth(), type, w.getTemperature(), w.getSendTime(),
				 w.getSize(), w.getResolution());
		 weatherDataV0.add(readData);
	 }
	 utilities.messages.ver0.WeatherDataVector requestV0=new utilities.messages.ver0.WeatherDataVector(weatherDataV0);
	 masg=requestV0;
	return masg;
}
}
