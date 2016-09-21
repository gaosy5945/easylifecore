package com.amarsoft.app.workflow.processdata;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.workflow.util.FlowHelper;

/**
 * 获取是否需要影像--待实现
 * @author xjzhao
 */
public class GetImageFlag implements IProcess {

	public String process(List<BusinessObject> bos, BusinessObjectManager bomanager,String paraName, String dataType,BusinessObject otherPara) throws Exception {
		if(bos == null || bos.isEmpty()) return "0";
		
		return FlowHelper.getImageFlag(bos.get(0));
	}

}
