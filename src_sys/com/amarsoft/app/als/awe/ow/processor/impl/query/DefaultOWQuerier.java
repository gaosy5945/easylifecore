package com.amarsoft.app.als.awe.ow.processor.impl.query;

import java.util.List;

import com.amarsoft.app.als.awe.ow.ALSBusinessProcess;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;

public class DefaultOWQuerier implements BusinessObjectOWQuerier {
	private BizObjectQuery query;
	private ALSBusinessProcess businessProcess;
	
	public int query(BusinessObject inputParameters, ALSBusinessProcess businessProcess) throws Exception {
		this.businessProcess=businessProcess;
		//此处保存原始where条件，新的where条件会自动增加fitler判断
		String whereClause = businessProcess.getASDataObject().getCustomProperties().getProperty("JBOWhereClause");
		if(StringX.isEmpty(whereClause)){
			businessProcess.getASDataObject().getCustomProperties().setProperty("JBOWhereClause",businessProcess.getASDataObject().getJboWhere());
		}

		query = businessProcess.getListQuery();
		List<DataElement> l=businessProcess.getASDataObject().getParameters();
		if(l!=null){
			for(DataElement d:l){
				query.setParameter(d);
			}
		}
		return 1;
	}

	public BusinessObject[] getBusinessObjectList(int fromIndex,
			int toIndex) throws Exception {
		query.setFirstResult(fromIndex);
	    query.setMaxResults(toIndex-fromIndex);
	    List<BizObject> jboResultSet = (List<BizObject>)query.getResultList(true);
		BusinessObject[] businessObjectArray = new BusinessObject[jboResultSet.size()];
		for(int i=0;i<jboResultSet.size();i++){
			businessObjectArray[i]=BusinessObject.convertFromBizObject(jboResultSet.get(i));
			businessObjectArray[i] = businessProcess.convertBusinessObject(businessObjectArray[i]);
			businessProcess.setDefaultValue(businessObjectArray[i]);
			
			String[] keys = businessObjectArray[i].getAttributeIDArray();
			for(String key:keys)
			{
				if(businessObjectArray[i].hasSubBizObject(key)){
					List<BusinessObject> relativeObjects = businessObjectArray[i].getBusinessObjects(key);
					for(BusinessObject relativeObject:relativeObjects){
						if(!StringX.isEmpty(relativeObject.getKeyString())){
							relativeObject.changeState(BizObject.STATE_SYNC);
						}
					}
				}
			}
		}

		return businessObjectArray;
	}

	@Override
	public int getTotalCount() throws Exception {
		return query.getTotalCount();
	}
}
