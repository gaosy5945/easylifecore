/**
 * 
 */
package com.amarsoft.app.als.reserve.model;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * ��������ֵ�������������Ϣ
 * @author xyli
 * @2014-5-13
 */
public class ReserveApply {
	
	private BizObjectManager bmRA;
	
	private BizObject bizObject;
	
	private JBOTransaction tx;
	
	private String objectNo;
	
	
	public ReserveApply(JBOTransaction tx,String objectNo){
		try {
			bmRA = JBOFactory.getBizObjectManager(ReserveJBOClass.RESERVE_APPLY);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bmRA);
			}
			
			if(!StringX.isEmpty(objectNo)){
				this.objectNo = objectNo;
				BizObject boRA = bmRA.createQuery("SERIALNO=:serialNo").setParameter("serialNo", objectNo).getSingleResult(null != tx);
				if(null != boRA){
					this.bizObject = boRA;
				}
			}
		} catch (JBOException e) {
			ARE.getLog().error("�����ֵ����������� �쳣", e);
		}
	}

	public BizObject newBizObject(){
		try {
			if(null == bizObject){
				bizObject = bmRA.newObject();
			}
		} catch (JBOException e) {
			ARE.getLog().error("�½�������� �쳣", e);
		}
		
		return bizObject;
	}
	
	public void setAttrValues(Map<String,Object> map){
		bizObject.setAttributesValue(map);
	}
	
	public void saveObject(){
		try {
			bmRA.saveObject(bizObject);
		} catch (JBOException e) {
			ARE.getLog().error("��������쳣", e);
		}
	}
	
	@SuppressWarnings("unchecked")
	public List<BizObject> getRelaCashFlow(JBOTransaction tx,String objectNo){
		List<BizObject> list = new ArrayList<BizObject>();
		try {
			BizObjectManager bmData = JBOFactory.getBizObjectManager(ReserveJBOClass.RESERVE_PREDICTDATA);
			if(null != tx){tx.join(bmData);}
			list = bmData.createQuery("ObjectNo=:sObjectNo").setParameter("sObjectNo", objectNo).getResultList(false);
		} catch (JBOException e) {
			ARE.getLog().error("��ѯ�������ֽ�����Ϣ �쳣", e);
		}
		
		return list;
	}

	public BizObject getBizObject() {
		return bizObject;
	}

	public String getObjectNo() {
		return objectNo;
	}

	public void setBizObject(BizObject bizObject) {
		this.bizObject = bizObject;
	}

	public void setObjectNo(String objectNo) {
		this.objectNo = objectNo;
	}
	
}
