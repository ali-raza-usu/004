package exp.ftp;

public class Controller {

	public static void main(String args[]) {
		FTPServer.main(null);
		try {
			Thread.sleep(200);
		} catch (InterruptedException e) {
			e.printStackTrace();
		}
		FTPClient.main(null);
	}
}
