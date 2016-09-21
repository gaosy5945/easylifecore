package com.amarsoft.app.als.sys.message.model;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.ServletContext;

import com.amarsoft.are.util.json.JSONEncoder;


public class ChartManage {
	private ServletContext application;
	private Map<String,Object> userMap;
	public ChartManage(ServletContext application){
		this.application=application;
		if(this.application.getAttribute("Message")==null){
			userMap=new HashMap<String,Object>();
			this.application.setAttribute("Message", userMap);
		}else{
			userMap=(Map<String,Object>)this.application.getAttribute("Message");
		}
	}
	
	public String putMessage(String fromUserid,String toUserid,String message){
		ChartBean chartBean=new ChartBean(fromUserid,toUserid,message);
		return this.putMessage(chartBean);
	}
	
	public String putMessage(ChartBean chartBean){
		String userId=chartBean.getToUser();
		List<Map> charLst;
		if(userMap.get(userId)!=null){
			  charLst=(List<Map>)userMap.get(userId);
		}else{
			charLst=new ArrayList<Map>();
		}
		charLst.add(chartBean.getMessageMap());
		userMap.put(userId, charLst);
		return "true";
	}
	
	public String getMessage(String userid){
		if(userMap.get(userid)==null){
			return "";
		}
		List<Map> lst=(List<Map>)userMap.get(userid);
		if(lst==null || lst.size()==0) return "";
		return JSONEncoder.encode(lst);
	}
}
