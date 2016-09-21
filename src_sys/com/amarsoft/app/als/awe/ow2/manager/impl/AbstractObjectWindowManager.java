package com.amarsoft.app.als.awe.ow2.manager.impl;

import com.amarsoft.app.als.awe.ow2.manager.ObjectWindowManager;
import com.amarsoft.app.base.businessobject.BusinessObject;

public abstract class AbstractObjectWindowManager implements ObjectWindowManager{
	private BusinessObject owconfig  = null;
	
	public final BusinessObject getObjectWindowConfig() {
		return owconfig;
	}

	public void setOwconfig(BusinessObject owconfig) {
		this.owconfig = owconfig;
	}
	
}
