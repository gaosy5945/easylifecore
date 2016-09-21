package com.amarsoft.app.oci.ws.crqs;

public class CRQSResult {
	private boolean result = false;
	private String message = "";
	public boolean getResult() {
		return result;
	}
	public void setResult(boolean result) {
		this.result = result;
	}
	public String getMessage() {
		return message;
	}
	public void setMessage(String message) {
		this.message = message;
	}
}
