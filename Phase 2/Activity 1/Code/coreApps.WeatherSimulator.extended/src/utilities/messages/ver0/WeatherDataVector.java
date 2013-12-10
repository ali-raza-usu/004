package utilities.messages.ver0;

import java.io.Serializable;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

import utilities.Message;
import utilities.MessageVersion;

public class WeatherDataVector extends MessageVersion implements Serializable {

	private static final long serialVersionUID = 1L;
	private UUID responseId = null;

	public static enum LocType {
		LAND, SEA;
	}

	public static enum ObservationType {
		MANUAL, AUTOMATIC;
	}

	private List<WeatherDataReading> _readings = new ArrayList<WeatherDataReading>();

	public WeatherDataVector(List<WeatherDataReading> _readings) {
		this.setVersion("0.0");
		this._readings = _readings;
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

	public UUID getResponseId() {
		return responseId;
	}

	public void setResponseId(UUID responseId) {
		this.responseId = responseId;
	}
}
