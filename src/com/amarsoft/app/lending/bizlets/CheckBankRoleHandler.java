package com.amarsoft.app.lending.bizlets;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.awe.dw.handler.impl.CommonHandler;

public class CheckBankRoleHandler extends CommonHandler{

	/**
	 * @hzcheng 2013-11-27
	 * 
	 * 授信组织方式牵头行判断
	 * history 2014-04-17 xfliu  将保存校验改为新增时如果已经存在牵头行，则只提供其他选择，屏蔽牵头行选项；
	 *                           将查询可以修改此方法，不会影响其他逻辑
	 */
	private String objectNo = "";
	private String objectType = "";

	public String getObjectNo() {
		return objectNo;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}

	public String getObjectType() {
		return objectType;
	}

	public void setObjectType(String objectType) {
		this.objectType = objectType;
	}
	/**
	 * 判断牵头行记录是否存在
	 * @param objectNo
	 * @param objectType
	 * @return
	 * @throws JBOException
	 */
	public static String isExistLeadRole(String objectNo,String objectType) throws JBOException{
		BizObjectManager m = JBOFactory.getBizObjectManager("jbo.app.BUSINESS_PROVIDER");
		List<BizObject> boList= m.createQuery("ObjectNo=:ObjectNo and ObjectType=:ObjectType").setParameter("ObjectNo", objectNo).setParameter("ObjectType", objectType).getResultList(false);
		String returnMessage = "FALSE";
		if(boList.size()>0){
			returnMessage = "TRUE";
		}
		return returnMessage;
	}
	/**
	 * 判断牵头行记录是否存在
	 * @return
	 * @throws Exception
	 */
	public String isExistLeadRole() throws Exception{
		return isExistLeadRole(objectNo,objectType);
	}
}