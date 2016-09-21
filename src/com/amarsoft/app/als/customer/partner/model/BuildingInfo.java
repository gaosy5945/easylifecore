package com.amarsoft.app.als.customer.partner.model;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * 楼盘信息
 * @author 
 *
 */
public class BuildingInfo {
	BizObject bo;
	BizObjectManager bm;
	JBOTransaction tx;
	
	/**
	 * 构造方法
	 * @param serialNo
	 * @param tx
	 * @throws JBOException
	 */
	public BuildingInfo(String serialNo ,JBOTransaction tx) throws JBOException{
		bm = JBOFactory.getBizObjectManager(CustomerConst.BUILDING_INFO);
		if(tx!=null){
			this.tx=tx;
			tx.join(bm);
		}
		bo = bm.createQuery("o.serialNo=:serialNo").setParameter("serialNo", serialNo).getSingleResult(true);
		
	}
	
	/**
	 * 更新状态 1 启用 2 停用
	 * @param status
	 * @throws JBOException
	 */
	public void updateStatus(String status) throws JBOException{
		bo.setAttributeValue("status", status);
		bm.saveObject(bo);
	}
	
	public void removeBuilding() throws Exception{
		if(tx==null) throw new Exception("事务为空不能删除信息");
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.BUILDING_DETAIL);
		tx.join(bom);
		bm.deleteObject(bo);
		bom.createQuery("delete from o where o.ESTATENO=:estateNo").setParameter("estateNo", bo.getAttribute("SerialNo").getString()).executeUpdate();
	}

}
