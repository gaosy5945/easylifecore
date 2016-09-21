package com.amarsoft.app.base.config.impl;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.ARE;
import com.amarsoft.are.util.xml.Document;

public class ApplicationConfig extends XMLConfig {
	protected Document document=null;
	private static ApplicationConfig applicationConfig=null;
	
	public static ApplicationConfig getApplicationConfig(){
		if(applicationConfig==null)applicationConfig=new ApplicationConfig();
		return applicationConfig;
	}
	
	@Override
	public void init(String configFile, int cacheSize) throws Exception {
		document = this.getDocument(configFile);
		config=BusinessObject.createBusinessObject(document.getRootElement());
		String functionConfigFiles=config.getString("functionConfigFiles");
		functionConfigFiles=ARE.replaceARETags(functionConfigFiles);
		FunctionConfig.getFunctionConfig().init(functionConfigFiles, cacheSize);
	}
}
