package aspects.ows;

import joinpoints.communication.SendEventJP;

import org.apache.log4j.Logger;

import baseaspects.communication.OneWaySendAspect;
import simulation.communication.Receiver;
import simulation.communication.Transmitter_8815;
import simulation.communication.Transmitter_8816;
import utilities.*;
import utilities.messages.*;

public aspect OnSend extends OneWaySendAspect{
	
	private Logger logger = Logger.getLogger(OnSend.class);	
	
	Object around(SendEventJP _sendEventJp): ConversationBegin(_sendEventJp)
	{		
		System.out.println("TARGER CLASS  "+ thisJoinPoint.getTarget().getClass() + " THIS CLAS "+ thisJoinPoint.getClass());
		System.out.println("OnSend is getting called  "+ getTargetClass());
		MessageVersion msg =  (MessageVersion)Encoder.decode(_sendEventJp.getBytes());
     	String logString = "OneWaySend: Sender: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " ID = " +_sendEventJp.getConversation().getId().toString();
     	
     	if(msg !=null)
     	{
	     	if(getTargetClass().equals(Receiver.class.getSimpleName()))
	     		{
	     		
	     			msg.setReceiver_version("0.0");
	     			System.out.println("onSend:  Receiver " + msg.getReceiver_version()+ " msg "+ msg.getClass());
	     			logString+="\n"+getTargetClass().getClass().getSimpleName()+" Message expected 1.0"+ " The version received is:"+msg.getVersion();
	     		}
	     	else //if(getTargetClass().equals(Transmitter_8815.class.getSimpleName()) || getTargetClass().equals(Transmitter_8816.class.getSimpleName()))
	     		{

	     		    msg.setReceiver_version("1.0");
		     		System.out.println("OnSend : transmitter "+ getTargetClass()+ " RECEIVER VERSION  " + msg.getReceiver_version() + " VERSION "+ msg.getVersion()+" msg "+ msg.getClass());
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