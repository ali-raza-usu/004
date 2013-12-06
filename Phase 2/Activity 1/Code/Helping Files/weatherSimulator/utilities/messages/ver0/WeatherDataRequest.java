package utilities.messages.ver0;

import org.junit.Test;

import utilities.Message;

public class WeatherDataRequest extends Message {


	private static final long serialVersionUID = 1L;

	public WeatherDataRequest() {
		this.setVersion("0.0");
	}

	@Test
	public void testRandomType() {
		int i = 0;
		while (i++ < 20) {
		}
	}


}
