package aspects.ows;

import joinpoints.communication.SendEventJP;

import org.apache.log4j.Logger;

import baseaspects.communication.OneWaySendAspect;
import utilities.*;
import utilities.messages.*;

public aspect OnSend extends OneWaySendAspect{
	
	private Logger logger = Logger.getLogger(OnSend.class);	
	
	after(SendEventJP _sendEventJp): ConversationBegin(_sendEventJp){
     	Message msg =  (Message)Encoder.decode(_sendEventJp.getBytes());
     	String logString = "OneWaySend: Sender: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " ID = " +_sendEventJp.getConversation().getId().toString();
     	logger.debug(getTargetClass() +"Message is "+ msg.getVersion());
     	if(msg !=null)
     	{
	     	if(getTargetClass().equals("Receiver"))
	     		{
	     			logString+="\n"+getTargetClass().getClass().getSimpleName()+" Message expected 1.0"+ " The version received is:"+msg.getVersion();
	     		}
	     	else if(getTargetClass().equals("Transmitter_8815") || getTargetClass().equals("Transmitter_8815"))
	     		{
	     			logString+="\n"+ getTargetClass().getClass().getSimpleName()+
	     					"Message expected 0.0"+ " The version received is:"+msg.getVersion();
	     		}
     	}
     	logger.debug(logString);		
		System.out.println(logString);
	}
	
	public static String getTargetClass() {
		StackTraceElement[] elements = Thread.currentThread().getStackTrace();
		String[] classes = elements[elements.length - 1].getClassName().split("\\.");
		return classes[classes.length - 1];
	}
}