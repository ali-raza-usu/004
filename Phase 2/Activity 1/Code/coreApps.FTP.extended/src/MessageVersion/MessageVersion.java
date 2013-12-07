package MessageVersion;

import utilities.Message;
public class MessageVersion extends Message {
	
	private String sender_version = "0.0";
	private String receiver_version = "1.0";
	
	
	public String getSender_version() {
		return sender_version;
	}

	public void setSender_version(String sender_version) {
		this.sender_version = sender_version;
	}

	public String getReceiver_version() {
		return receiver_version;
	}

	public void setReceiver_version(String receiver_version) {
		this.receiver_version = receiver_version;
	}

}
