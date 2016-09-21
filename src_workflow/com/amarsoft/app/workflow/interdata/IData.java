package com.amarsoft.app.workflow.interdata;

import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

/**
 * 通过对象类型、对象编号获取对象信息
 * @author 赵晓建
 */
public interface IData {
	
	/**
	 * 通过流程对象类型获取 业务数据和流程数据
	 * @param objectType
	 * @param bomanager
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception;
	
	
	/**
	 * 通过流程对象类型获取 业务数据
	 * @param objectType
	 * @param bomanager
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception;
	
	/**
	 * 内部数据代码转换
	 * @param boList
	 * @throws Exception
	 */
	public void transfer(BusinessObject bo) throws Exception;
	
	/**
	 * 对于一个流程多个业务的情况进行数据合并展示
	 * @param boList
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> group(List<BusinessObject> boList) throws Exception;
	
	/**
	 * 对象数据删除
	 * @param key
	 * @param sqlca
	 * @throws Exception
	 */
	public void cancel(String key,BusinessObjectManager bomanager) throws Exception;
	
	/**
	 * 对象数据终止
	 * @param key
	 * @param sqlca
	 * @throws Exception
	 */
	public void finish(String key,BusinessObjectManager bomanager) throws Exception;
	
}
