package com.amarsoft.app.base.config;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectCache;


public abstract class AbstractConfig {
	protected BusinessObjectCache cache=null;
	protected BusinessObject config=BusinessObject.createBusinessObject();
	
	public abstract void init(String configFile,int cacheSize) throws Exception;
	
	public BusinessObjectCache getCache() {
		return cache;
	}
	
	public BusinessObject getConfig() {
		return config;
	}
}
