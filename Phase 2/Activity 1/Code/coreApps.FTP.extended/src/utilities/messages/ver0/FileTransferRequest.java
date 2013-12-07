package utilities.messages.ver0;
import utilities.MessageVersion;

public class FileTransferRequest extends MessageVersion {

	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private String fileIndex = "";
	private String fileNames = "";

	public FileTransferRequest(String fileIndex, String fileNames) {
		this.setVersion("0.0");
		this.fileIndex = fileIndex;
		this.fileNames = fileNames;
	}

	public String getFileIndex() {
		return fileIndex;
	}

	public void setFileIndex(String fileName) {
		this.fileIndex = fileName;
	}

	public String getFileNames() {
		return fileNames;
	}

	public void setFileNames(String fileNames) {
		this.fileNames = fileNames;
	}

}
