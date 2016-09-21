package com.amarsoft.app.als.sys.message.model;

import java.io.Serializable;
import java.util.HashMap;
import java.util.Map;

import com.amarsoft.are.util.StringFunction;
import com.amarsoft.are.util.json.JSONEncoder;
import com.amarsoft.awe.util.DBKeyHelp;

public class ChartBean implements Serializable{
	private String message="";
	private String fromUser="";
	private String toUser="";
	private String inputTime="";
	private String serialNo="";
	
	public ChartBean(String fuser,String tuser,String message){
		this.setFromUser(fuser);
		this.setMessage(message);
		this.setToUser(tuser);
		this.inputTime=StringFunction.getTodayNow();
		serialNo=DBKeyHelp.getSerialNo();
	}
	
	public String getMessage() {
		return message;
	}

	public void setMessage(String message) {
		this.message = message;
	}

	public String getFromUser() {
		return fromUser;
	}

	public void setFromUser(String fromUser) {
		this.fromUser = fromUser;
	}

	public String getToUser() {
		return toUser;
	}

	public void setToUser(String toUser) {
		this.toUser = toUser;
	}

	/**
	 * 获得消息的MAP
	 * @return
	 */
	public Map<String,String> getMessageMap(){
		Map<String,String> map=new HashMap<String,String>();
		map.put("message", this.message);
		map.put("fromUser", this.fromUser);
		map.put("toUser", this.toUser);
		map.put("inputTime", this.inputTime); 
		map.put("serialNo", this.serialNo); 
		return map;
	}
	/**
	 * 获得json数据
	 */
	public String toJSONString() {
		return JSONEncoder.encode(getMessageMap());
	}
}
