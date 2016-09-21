package com.amarsoft.app.als.prd.config.loader;

import com.amarsoft.app.als.prd.config.loader.ProductConfig;
import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;

public class ProductConfigLoader extends AbstractLoader {
	
	public AbstractCache getCacheInstance() {
		
		return new ProductConfig();
	}
}
