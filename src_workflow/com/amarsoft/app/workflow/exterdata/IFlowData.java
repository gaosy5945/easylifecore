package com.amarsoft.app.workflow.exterdata;


import java.util.Map;

import com.amarsoft.app.base.businessobject.BusinessObjectManager;



/**
 * �����ȡ��������ӿ�
 * @author ������
 */
public interface IFlowData{
	/**
	 * ͨ�������ӿڻ�ȡ���̹���ϵͳ�ṩ����������
	 * @param para ����ӿڲ������ò���ͨ���������üӹ��õ�
	 * @return �ӿ����ݱ�׼����
	 */
	public abstract Map<String,Object> getData(Map<String,String> para,BusinessObjectManager bomanager) throws Exception;

}
