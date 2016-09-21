package com.amarsoft.app.als.customer.partner.action;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.app.als.customer.partner.model.BuildingInfo;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 楼盘信息的相关处理
 * @author Administrator
 *
 */
public class BuildingAction {
	
	private String serialNo;
	private String status;
	private String buildingName;
	
	/**
	 * 更新楼盘状态
	 * @return
	 * @throws JBOException 
	 */
	public String updateStatus() throws JBOException{
		if(isInUse()) return "3";
		try {
			new BuildingInfo(serialNo,null).updateStatus(status);
			return "1";
		} catch (JBOException e) {
			return "2";
		}
	}
	
	public String remove(JBOTransaction tx){
		try {
			if(isInUse()) return "3";
			new BuildingInfo(serialNo, tx).removeBuilding();
			return "1";
		} catch (Exception e) {
			e.printStackTrace();
			return "2";
		}
	}
	//判断楼盘是否可用，即是否被有效引用
	private Boolean isInUse() throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.PARTNER_PROJECT_RELATIVE);
		BizObject bo = bm.createQuery("" +
				//"objectType=:projectType and " +
				"accessoryNo=:accessoryNo" +
				//" and objectNo=:objectNo" +
				" and accessoryType=:accessoryType")
				//.setParameter("projectType",projectType).setParameter("objectNo", objectNo)
				.setParameter("accessoryNo", serialNo).setParameter("accessoryType",CustomerConst.PARTNER_RELATIVE_TYPE_6).getSingleResult(false);
		if(bo!=null) return true;//已经存在此关联
		return false;
	}
	
	public String nameCanUse() throws JBOException{
		BizObjectManager bm = JBOFactory.getBizObjectManager(CustomerConst.BUILDING_INFO);
		BizObject bo = bm.createQuery("buildingName=:buildingName").setParameter("buildingName", buildingName).getSingleResult(false);
		if(bo != null)return "1";
		return "2";
	}
	
	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}
	public String getStatus() {
		return status;
	}
	public void setStatus(String status) {
		this.status = status;
	}

	public String getBuildingName() {
		return buildingName;
	}

	public void setBuildingName(String buildingName) {
		this.buildingName = buildingName;
	}

}
