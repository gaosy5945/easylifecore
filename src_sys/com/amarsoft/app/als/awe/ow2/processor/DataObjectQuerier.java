package com.amarsoft.app.als.awe.ow2.processor;

import com.amarsoft.app.base.businessobject.BusinessObject;

public interface DataObjectQuerier {
	public BusinessObject[] getData(int fromIndex,int toIndex) throws Exception;
	public int query(OWBusinessProcessor businessProcess) throws Exception;
	public int getTotalCount() throws Exception;
}
