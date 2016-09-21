package com.amarsoft.app.als.sys.function.config;

import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;

public class SysFunctionLoader extends AbstractLoader{
	@Override
	public AbstractCache getCacheInstance() {
		return SysFunctionCache.getInstance();
	}
}
 