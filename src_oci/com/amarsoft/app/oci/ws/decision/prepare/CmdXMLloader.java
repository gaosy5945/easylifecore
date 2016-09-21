package com.amarsoft.app.oci.ws.decision.prepare;

import com.amarsoft.dict.als.cache.AbstractCache;
import com.amarsoft.dict.als.cache.loader.AbstractLoader;

public class CmdXMLloader extends AbstractLoader{

	@Override
	public AbstractCache getCacheInstance() {
		return CmdXMLConfig.newInstance();
	}
}