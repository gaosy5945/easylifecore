package com.amarsoft.app.oci;

import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;

public class OCIConfigLoader extends AbstractLoader {

	
	public AbstractCache getCacheInstance() {
		
		return new OCIConfig();
	}

}
