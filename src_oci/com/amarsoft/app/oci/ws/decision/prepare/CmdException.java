package com.amarsoft.app.oci.ws.decision.prepare;
/**
 * 
 * @author t-liuyc
 */

public class CmdException extends Exception{
	private String reason;
	public CmdException(String args) {
		super(args);
		this.reason = args;
	}
	
	public String getReason() {
		return reason;
	}
}
