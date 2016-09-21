package com.amarsoft.app.als.businesscomponent.analysis.dataloader;

import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

/**
 * 组件数据加载器
 * @author amarsoft
 *
 */
public interface ComponentDataLoader{
	public List<BusinessObject> getComponentDataList(BusinessObject businessObject,BusinessObject component,BusinessObjectManager bomanager) throws Exception;
}
