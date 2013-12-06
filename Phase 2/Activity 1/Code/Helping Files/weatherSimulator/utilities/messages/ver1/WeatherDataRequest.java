package utilities.messages.ver1;

import org.junit.Test;

import utilities.Message;
import utilities.messages.ver0.RequestType;

public class WeatherDataRequest extends Message {


	private static final long serialVersionUID = 1L;

	public WeatherDataRequest() {
		this.setVersion("1.0");
	}

	@Test
	public void testRandomType() {
		int i = 0;
		while (i++ < 20) {
		}
	}


}
