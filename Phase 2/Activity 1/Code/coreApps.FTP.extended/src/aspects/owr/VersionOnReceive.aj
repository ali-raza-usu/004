package aspects.owr;


import joinpoints.communication.ReceiveEventJP;
import utilities.MessageVersion;
import baseaspects.communication.OneWayReceiveAspect;
import utilities.Encoder;
//import utilities.Message;
import utilities.messages.ver0.FileTransferAck;
import utilities.messages.ver0.FileTransferRequest;
import utilities.messages.ver0.FileTransferResponse;

import org.apache.log4j.Logger;

import exp.ftp.FTPClient;
import exp.ftp.FTPServer;


public aspect VersionOnReceive extends OneWayReceiveAspect{
	private Logger logger = Logger.getLogger(VersionOnReceive.class);
	
	after (ReceiveEventJP _receiveEventJp):  ConversationEnd(_receiveEventJp)
	{
		MessageVersion msg =  (MessageVersion)Encoder.decode(_receiveEventJp.getBytes());
		String logString = "";//"OneWayReceiver: Receiver: "+getTargetClass() + " - Message "+ msg.getClass().getSimpleName() + " ID = " +_receiveEventJp.getConversation().getId().toString();
		
		if(msg != null)
		{
			
			if(msg.getClass().getSimpleName().equals(utilities.messages.ver0.FileTransferRequest.class.getSimpleName()))
		 	{	
				msg = ChangeVersion(msg);
		 	}
				
			else if(msg.getClass().getSimpleName().equals(utilities.messages.ver0.FileTransferResponse.class.getSimpleName()))
			{
				msg = ChangeVersion(msg);
			}
		 	
			else if(msg.getClass().getSimpleName().equals(utilities.messages.ver0.FileTransferAck.class.getSimpleName()))
		 	{
				msg = ChangeVersion(msg);
		 	}
	 	
		 		_receiveEventJp.setBytes(Encoder.encode(msg));
		 		logString+= "\n"+msg.getClass().getSimpleName()+ "Message Version=" + msg.getVersion().toString();
		 		logger.debug(logString);		
		 		System.out.println(logString);
		}
	}


	public MessageVersion ChangeVersion(MessageVersion msg) {
		
		if((!msg.getVersion().equals(msg.getReceiver_version())) && getTargetClass().equals(FTPServer.class.getSimpleName()))
		{// server
			
			System.out.println("Version on receive  server received "+ msg);
			if(msg.getClass().getSimpleName().equals(FileTransferRequest.class.getSimpleName())){
			utilities.messages.ver1.FileTransferRequest requestV1=(utilities.messages.ver1.FileTransferRequest) msg;
			utilities.messages.ver0.FileTransferRequest requestV0= new utilities.messages.ver0.FileTransferRequest(requestV1.getFileIndex(), requestV1.getFileNames());
			msg  = requestV0;
			}
			if(msg.getClass().getSimpleName().equals(FileTransferResponse.class.getSimpleName())){
				utilities.messages.ver1.FileTransferResponse responseV1 = (utilities.messages.ver1.FileTransferResponse)msg;
				utilities.messages.ver0.FileTransferResponse responseV0=new utilities.messages.ver0.FileTransferResponse(responseV1.getFileName(),responseV1.getChunkBytes(),responseV1.isComplete());
				msg  = responseV0;
			}
			if(msg.getClass().getSimpleName().equals(FileTransferAck.class.getSimpleName())){
			utilities.messages.ver1.FileTransferAck ackV1 = (utilities.messages.ver1.FileTransferAck)msg;
			utilities.messages.ver0.FileTransferAck ackV0=new utilities.messages.ver0.FileTransferAck(ackV1.isComplete());
			msg  = ackV0;
			}

		}
		else if((!msg.getVersion().equals(msg.getReceiver_version())) && getTargetClass().equals("FTPClient"))
		{//client
			if(msg.getClass().getSimpleName().equals(FileTransferRequest.class.getSimpleName())){
				utilities.messages.ver0.FileTransferRequest requestV0=(utilities.messages.ver0.FileTransferRequest) msg;
				utilities.messages.ver1.FileTransferRequest requestV1= new utilities.messages.ver1.FileTransferRequest(requestV0.getFileIndex(), requestV0.getFileNames());
				msg  = requestV1;
			}
			if(msg.getClass().getSimpleName().equals(FileTransferResponse.class.getSimpleName())){
				 utilities.messages.ver0.FileTransferResponse responseV0 = (utilities.messages.ver0.FileTransferResponse)msg;
				 utilities.messages.ver1.FileTransferResponse responseV1=new utilities.messages.ver1.FileTransferResponse(responseV0.getFileName(),responseV0.getChunkBytes(),responseV0.isComplete());
				 msg  = responseV1;
			}
			if(msg.getClass().getSimpleName().equals(FileTransferAck.class.getSimpleName())){
				 utilities.messages.ver0.FileTransferAck ackV0 = (utilities.messages.ver0.FileTransferAck)msg;
				 utilities.messages.ver1.FileTransferAck ackV1=new utilities.messages.ver1.FileTransferAck(ackV0.isComplete());
				 msg  = ackV1;
			}
		}
		return msg;
	}

	
	public static String getTargetClass() {
		StackTraceElement[] elements = Thread.currentThread().getStackTrace();
		String[] classes = elements[elements.length - 1].getClassName().split("\\.");
		return classes[classes.length - 1];
	}
}
