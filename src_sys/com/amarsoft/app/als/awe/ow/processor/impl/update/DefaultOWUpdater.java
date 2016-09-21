package com.amarsoft.app.als.awe.ow.processor.impl.update;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.als.businessobject.action.BusinessObjectFactory;

public class DefaultOWUpdater implements BusinessObjectOWUpdater {

	@Override
	public List<BusinessObject> update(BusinessObject businessObject,
			ALSBusinessProcess businessProcess) throws Exception {
		businessObject.generateKey();

		Map<String, String> needUpdateJBOClassMap = ObjectWindowHelper.getNeedUpdateJBOClass(businessProcess.getASDataObject());
		for(Iterator<String> it=needUpdateJBOClassMap.keySet().iterator();it.hasNext();){
			String jboClassAlias = it.next();
			String jboClassName = needUpdateJBOClassMap.get(jboClassAlias);
			BusinessObject relativeObject = businessObject.getBusinessObject(jboClassName);
			if(relativeObject==null) throw new Exception("DONO={"+businessProcess.getASDataObject().getDONO()+"}中，JBOClassName={"+jboClassName+"}的对象未找到，无法保存！");
			businessProcess.getBusinessObjectManager().updateBusinessObject(relativeObject);
		}

		BusinessObjectFactory.save(businessObject, businessProcess.getBusinessObjectManager());
		List<BusinessObject> result = new ArrayList<BusinessObject>();
		result.add(businessObject);
		return result;
	}

	@Override
	public List<BusinessObject> update(List<BusinessObject> businessObjectList,
			ALSBusinessProcess businessProcess) throws Exception {
		for(BusinessObject businessObject:businessObjectList){
			this.update(businessObject, businessProcess);
		}
		return businessObjectList;
	}

}
