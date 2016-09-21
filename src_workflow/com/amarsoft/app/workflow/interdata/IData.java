package com.amarsoft.app.workflow.interdata;

import java.util.HashMap;
import java.util.List;

import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;

/**
 * ͨ���������͡������Ż�ȡ������Ϣ
 * @author ������
 */
public interface IData {
	
	/**
	 * ͨ�����̶������ͻ�ȡ ҵ�����ݺ���������
	 * @param objectType
	 * @param bomanager
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getFlowObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception;
	
	
	/**
	 * ͨ�����̶������ͻ�ȡ ҵ������
	 * @param objectType
	 * @param bomanager
	 * @param parameters
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> getObjects(String objectType,BusinessObjectManager bomanager,Object... parameters) throws Exception;
	
	/**
	 * �ڲ����ݴ���ת��
	 * @param boList
	 * @throws Exception
	 */
	public void transfer(BusinessObject bo) throws Exception;
	
	/**
	 * ����һ�����̶��ҵ�������������ݺϲ�չʾ
	 * @param boList
	 * @return
	 * @throws Exception
	 */
	public List<BusinessObject> group(List<BusinessObject> boList) throws Exception;
	
	/**
	 * ��������ɾ��
	 * @param key
	 * @param sqlca
	 * @throws Exception
	 */
	public void cancel(String key,BusinessObjectManager bomanager) throws Exception;
	
	/**
	 * ����������ֹ
	 * @param key
	 * @param sqlca
	 * @throws Exception
	 */
	public void finish(String key,BusinessObjectManager bomanager) throws Exception;
	
}
