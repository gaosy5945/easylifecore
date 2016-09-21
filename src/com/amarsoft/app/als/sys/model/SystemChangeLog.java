package com.amarsoft.app.als.sys.model;

import java.util.HashMap;
import java.util.Map;

import com.amarsoft.app.als.sys.tools.SystemConst;
import com.amarsoft.app.base.util.DateHelper;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.context.ASUser;

/**
 * ϵͳ�����־
 * @author Administrator
 *
 */
public class SystemChangeLog {
	private BizObjectManager m;
	private BizObject logBo;
	public Map<String,String> paraMap; 
	public static String NEW_RECORD="1";//��¼����
	public static String UPDATE_RECORD="2";//��¼����
	public static String DELETE_RECORD="3";//��¼ɾ��

	private String doNO="";
	private String doName="";
	private String tableName="";
	private String changeType="";
	private String objectNo="",objectType="";
	/**
	 * ϵͳ��־��ʼ��
	 * @param tx
	 * @throws JBOException
	 */
	public SystemChangeLog(JBOTransaction tx,String objectType,String objectNo) throws JBOException
	{
		this.objectNo=objectNo;
		this.objectType=objectType;
		m=JBOFactory.getBizObjectManager(SystemConst.JBO_SYSTEM_CHANGE_LOG);
		if(tx!=null) tx.join(m);
		paraMap=new HashMap<String,String>();
		logBo=m.newObject();
		logBo.setAttributeValue("objectType", objectType);
		logBo.setAttributeValue("objectNo", objectNo);
	}
 
	private String displaylog="";
	
	/**
	 * �����µ���־
	 * @param map
	 * @return
	 * @throws Exception 
	 * @since  2012-8-15 ����08:36:31
	 */
	public BizObject newLog(Map<String,String> map) throws Exception
	{
//		logBo.setAttributeValue("SerialNo", serialNo);
		logBo.setAttributeValue("DoNo", this.doNO);
		logBo.setAttributeValue("DoName",this.doName);
		logBo.setAttributeValue("ObjectNo", objectNo);
		logBo.setAttributeValue("ObjectType", objectType);
		logBo.setAttributeValue("TableName",this.tableName);
		logBo.setAttributeValue("ChangeType", changeType);
		logBo.setAttributeValue("DisplayLog",displaylog);//displayLog,DisplayLogMap
		logBo.setAttributesValue(map); 
		logBo.setAttributeValue("InputTime", DateHelper.getBusinessDate());
		m.saveObject(logBo);
		return  logBo;
	}
	
	
	public BizObject saveLog(Map<String,String> map) throws Exception
	{
		if(map!=null){
	//		logBo.setAttributesValue(map);
		}
		logBo.setAttributeValue("InputTime", DateHelper.getBusinessDate());
		//m.saveObject(logBo);
		return  logBo;
	}
	
	
	/**
	 * ��������
	 * @param skey ����
	 * @param value  ����ֵ
	 * @throws JBOException
	 * @since  2012-8-15 ����09:37:18
	 */
	public void setAttribute(String skey,String value) throws JBOException
	{
		paraMap.put(skey, value);
		logBo.setAttributeValue(skey, value);
	}
	/**
	 * ���ò���
	 * @param paraMap
	 */
	public void setParaMap(Map<String, String> paraMap) {
		this.paraMap = paraMap;
	}
	/**
	 * �����û�
	 * @param user
	 * @throws JBOException
	 * @since  2012-8-15 ����09:37:03
	 */
	public void setUser(ASUser user) throws JBOException
	{
		logBo.setAttributeValue("UserID", user.getUserID());
		logBo.setAttributeValue("OrgID", user.getBelongOrg().getOrgID()); 
	}
	/**
	 * �����û�
	 * @param userID
	 * @throws Exception 
	 */
	public void serUser(String userID) throws Exception
	{
		ASUserObject user=ASUserObject.getUser(userID);
		logBo.setAttributeValue("UserID", user.getUserID());
		logBo.setAttributeValue("OrgID", user.getBelongOrg().getOrgID()); 
	}
}
