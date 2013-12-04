package utilities.messages.ver0;

import java.util.ArrayList;
import java.util.List;

import utilities.Message;

public class WeatherDataVector extends Message {

	private static final long serialVersionUID = 1L;

	public static enum LocType {
		LAND, SEA;
	}

	public static enum ObservationType {
		MANUAL, AUTOMATIC;
	}

	private List<WeatherDataReading> _readings = new ArrayList<WeatherDataReading>();

	public WeatherDataVector(List<WeatherDataReading> _readings) {
		this._readings = _readings;
		this.setVersion("0.0");
	}

	public WeatherDataVector() {
		this.setVersion("0.0");
	}

	public List<WeatherDataReading> getReadings() {
		return _readings;
	}

	public void setReadings(List<WeatherDataReading> _readings) {
		this._readings = _readings;
	}
}
