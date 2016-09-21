package com.amarsoft.app.als.customer.partner.action;

import com.amarsoft.app.als.customer.partner.model.PartnerProjectInfo;
import com.amarsoft.are.jbo.JBOException;
/**
 * 初始化项目关联关系
 * @author Administrator
 *
 */
public class ProjectRelativeAction {
	
	private String objectNo;
	private String accessoryNo;
	private String accessoryName;
	private String accessoryType;
	/**
	 * 建立关联关系
	 * @return
	 * @throws JBOException 
	 */
	public String initRelative() throws JBOException{
		PartnerProjectInfo pp = new PartnerProjectInfo(objectNo);
		pp.initProjectRelative(null,accessoryType,accessoryNo,accessoryName);
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
