/**
 * 
 */
package com.amarsoft.app.als.reserve.model;

import java.util.Map;

import com.amarsoft.are.ARE;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.StringX;

/**
 * 描述：现金流信息对象	
 * @author xyli
 * @2014-5-13
 */
public class ReservePredictdata {
	
	private BizObjectManager bmData;
	
	private BizObject bizObject;
	
	private JBOTransaction tx;
	
	private String serialNo;
	
	
	public ReservePredictdata(JBOTransaction tx,String serialNo){
		try {
			bmData = JBOFactory.getBizObjectManager(ReserveJBOClass.RESERVE_PREDICTDATA);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bmData);
			}
			
			if(!StringX.isEmpty(serialNo)){
				this.serialNo = serialNo;
				BizObject boRA = bmData.createQuery("SERIALNO=:serialNo").setParameter("serialNo", serialNo).getSingleResult(null != tx);
				if(null != boRA){
					this.bizObject = boRA;
				}
			}
		} catch (JBOException e) {
			ARE.getLog().error("构造现金流信息对象 异常", e);
		}
	}

	public BizObject newBizObject(){
		try {
			if(null == bizObject){
				bizObject = bmData.newObject();
			}
		} catch (JBOException e) {
			ARE.getLog().error("新建现金流信息对象 异常", e);
		}
		
		return bizObject;
	}
	
	public void setAttrValues(Map<String,Object> map){
		bizObject.setAttributesValue(map);
	}
	
	public void saveObject(){
		try {
			bmData.saveObject(bizObject);
		} catch (JBOException e) {
			ARE.getLog().error("保存现金流信息对象异常", e);
		}
	}

	public BizObject getBizObject() {
		return bizObject;
	}

	public void setBizObject(BizObject bizObject) {
		this.bizObject = bizObject;
	}

	public String getSerialNo() {
		return serialNo;
	}

	public void setSerialNo(String serialNo) {
		this.serialNo = serialNo;
	}

}
