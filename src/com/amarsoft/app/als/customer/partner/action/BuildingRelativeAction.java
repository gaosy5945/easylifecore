package com.amarsoft.app.als.customer.partner.action;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.partner.model.PartnerProjectInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

public class BuildingRelativeAction {
	
	private String objectNo;
	private String accessoryNo;
	private String accessoryName;
	private String accessoryType;
	/**
	 * 建立关联关系
	 * @return
	 * @throws JBOException 
	 */
	public String initRelative(JBOTransaction tx){
		PartnerProjectInfo pp = new PartnerProjectInfo(objectNo);
		try {
			//String projectType = pp.getProjectType();
			BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.PARTNER_PROJECT_RELATIVE);
			tx.join(bm);
			BizObject bo = bm.createQuery("" +
					//"objectType=:projectType and " +
					"accessoryNo=:accessoryNo" +
					//" and objectNo=:objectNo" +
					" and accessoryType=:accessoryType")
					//.setParameter("projectType",projectType).setParameter("objectNo", objectNo)
					.setParameter("accessoryNo", accessoryNo).setParameter("accessoryType",accessoryType).getSingleResult(false);
			if(bo!=null) return "false";//已经存在此关联
			pp.initProjectRelative(null,accessoryType,accessoryNo,accessoryName);
		} catch (JBOException e) {
			e.printStackTrace();
			return "error";
		}
		return "true";
	}
	
	public String getObjectNo() {
		return objectNo;
	}
	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	public String getAccessoryNo() {
		return accessoryNo;
	}
	public void setAccessoryNo(String accessoryNo) {
		this.accessoryNo = accessoryNo;
	}
	public String getAccessoryName() {
		return accessoryName;
	}
	public void setAccessoryName(String accessoryName) {
		this.accessoryName = accessoryName;
	}
	public String getAccessoryType() {
		return accessoryType;
	}
	public void setAccessoryType(String accessoryType) {
		this.accessoryType = accessoryType;
	}
}
