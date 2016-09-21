package com.amarsoft.app.als.sys;

import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;
import com.amarsoft.app.als.sys.SystemConfig;

public class SystemConfigLoader  extends AbstractLoader{

	@Override
	public AbstractCache getCacheInstance() {
		// TODO Auto-generated method stub
		return new  SystemConfig();
	}

}
