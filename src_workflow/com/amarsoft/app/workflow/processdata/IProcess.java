package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

public interface IProcess {
	/**
	 * ͨ��ָ���߼����������м����ֵ
	 * @param bos
	 * @param conn
	 * @param paraName
	 * @return
	 * @throws Exception
	 */
	public String process(List<BusinessObject> bos,BusinessObjectManager bomanager,String paraName,String dataType,BusinessObject otherPara) throws Exception;
}
