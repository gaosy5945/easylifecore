package com.amarsoft.app.base.config.impl;

import java.io.File;
import java.io.FileInputStream;
import java.io.InputStream;

import com.amarsoft.app.base.businessobject.BusinessObjectCache;
import com.amarsoft.app.base.config.AbstractConfig;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.are.io.FileTool;
import com.amarsoft.are.util.json.JSONDecoder;
import com.amarsoft.are.util.json.JSONObject;

public abstract class JSONConfig extends AbstractConfig{
	private JSONObject jsonObject=null;
	
	public void init(String configFile,int cacheSize) throws Exception{
		cache=new BusinessObjectCache(cacheSize);
		File f = FileTool.findFile(configFile);
		if (f == null) {
			throw new ALSException(" ");
		}
		InputStream in = new FileInputStream(f);
		try{
			 byte[] buf = new byte[1024];
	         StringBuffer sb=new StringBuffer();
	         while((in.read(buf))!=-1){
	             sb.append(new String(buf));    
	             buf=new byte[1024];
	         }
	         jsonObject=JSONDecoder.decode(sb.toString());
		}
		catch(Exception e){
			throw e;
		}
		finally {
			in.close();
		}
	}
	
	public JSONObject getJsonObject() {
		return jsonObject;
	}
	
	
}
