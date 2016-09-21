package com.amarsoft.app.als.customer.partner.model;

import com.amarsoft.app.als.customer.model.CustomerConst;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;

/**
 * ¥����Ϣ
 * @author 
 *
 */
public class BuildingInfo {
	BizObject bo;
	BizObjectManager bm;
	JBOTransaction tx;
	
	/**
	 * ���췽��
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
	 * ����״̬ 1 ���� 2 ͣ��
	 * @param status
	 * @throws JBOException
	 */
	public void updateStatus(String status) throws JBOException{
		bo.setAttributeValue("status", status);
		bm.saveObject(bo);
	}
	
	public void removeBuilding() throws Exception{
		if(tx==null) throw new Exception("����Ϊ�ղ���ɾ����Ϣ");
		BizObjectManager bom = JBOFactory.getBizObjectManager(CustomerConst.BUILDING_DETAIL);
		tx.join(bom);
		bm.deleteObject(bo);
		bom.createQuery("delete from o where o.ESTATENO=:estateNo").setParameter("estateNo", bo.getAttribute("SerialNo").getString()).executeUpdate();
	}

}
