package aspects.ows;

import joinpoints.communication.SendEventJP;

import org.apache.log4j.Logger;

import baseaspects.communication.OneWaySendAspect;
import utilities.*;
import utilities.messages.*;

public aspect OnSend extends OneWaySendAspect{
	
	private Logger logger = Logger.getLogger(OnSend.class);	
	
	Object around(SendEventJP _sendEventJp): ConversationBegin(_sendEventJp)
	{		
		MessageVersion msg =  (MessageVersion)Encoder.decode(_sendEventJp.getBytes());
     	String logString = "OneWaySend: Sender: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " ID = " +_sendEventJp.getConversation().getId().toString();
     	
     	if(msg !=null)
     	{
	     	if(getTargetClass().equals("Receiver"))
	     		{
	     			msg.setReceiver_version("0.0");
	     			logString+="\n"+getTargetClass().getClass().getSimpleName()+" Message expected 1.0"+ " The version received is:"+msg.getVersion();
	     		}
	     	else if(getTargetClass().equals("Transmitter_8815") || getTargetClass().equals("Transmitter_8815"))
	     		{
	     		    msg.setReceiver_version("1.0");
	     			logString+="\n"+ getTargetClass().getClass().getSimpleName()+
	     					"Message expected 0.0"+ " The version received is:"+msg.getVersion();
	     		}
     	}
    	_sendEventJp.setBytes(Encoder.encode(msg));
		return proceed(_sendEventJp);
	}
	
	public static String getTargetClass() {
		StackTraceElement[] elements = Thread.currentThread().getStackTrace();
		String[] classes = elements[elements.length - 1].getClassName().split("\\.");
		return classes[classes.length - 1];
	}
}