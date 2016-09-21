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
 * 描述：减值计提参数配置对象
 * @author xyli
 * @2014-5-13
 */
public class ReservePara {
	
	private BizObjectManager bmPara;
	
	private BizObject bizObject;
	
	private JBOTransaction tx;
	
	private String serialNo;
	
	
	public ReservePara(JBOTransaction tx,String serialNo){
		try {
			bmPara = JBOFactory.getBizObjectManager(ReserveJBOClass.RESERVE_PARA);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bmPara);
			}
			
			if(!StringX.isEmpty(serialNo)){
				this.serialNo = serialNo;
				BizObject boRA = bmPara.createQuery("SERIALNO=:serialNo").setParameter("serialNo", serialNo).getSingleResult(null != tx);
				if(null != boRA){
					this.bizObject = boRA;
				}
			}
		} catch (JBOException e) {
			ARE.getLog().error("构造对象 异常", e);
		}
	}
	
	public ReservePara(JBOTransaction tx,String accountMonth,String customerType){
		try {
			bmPara = JBOFactory.getBizObjectManager(ReserveJBOClass.RESERVE_PARA);
			if(null != tx){
				this.tx = tx;
				this.tx.join(bmPara);
			}
			
			if(!StringX.isEmpty(accountMonth) && !StringX.isEmpty(customerType)){
				BizObject boRA = bmPara.createQuery("ACCOUNTMONTH=:sAccountMonth and CUSTOMERTYPE=:sCustomerType")
									   .setParameter("sAccountMonth", accountMonth)
									   .setParameter("sCustomerType", customerType)
									   .getSingleResult(null != tx);
				if(null != boRA){
					this.bizObject = boRA;
				}
			}
		} catch (JBOException e) {
			ARE.getLog().error("构造对象 异常", e);
		}
	}

	public BizObject newBizObject(){
		try {
			if(null == bizObject){
				bizObject = bmPara.newObject();
			}
		} catch (JBOException e) {
			ARE.getLog().error("新建对象 异常", e);
		}
		
		return bizObject;
	}
	
	public double getLossRate(String classifyResult){
		//codeNO:ClassifyResult
		
		return 0;
	}
	
	public void setAttrValues(Map<String,Object> map){
		bizObject.setAttributesValue(map);
	}
	
	public void saveObject(){
		try {
			bmPara.saveObject(bizObject);
		} catch (JBOException e) {
			ARE.getLog().error("保存对象异常", e);
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
