package com.amarsoft.app.als.recoverymanage.handler;

import java.util.List;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.lang.StringX;

/**
 * 名称转化
 * @author zqliu
 *
 */
public class RecoverNameManage  {
	
	/**
	 * 获取日常联系人
	 * @param sCustomerId
	 * @param sCustomerType
	 * @return
	 */
	public static String getNorPersonerName(String sCustomerId,String  sCustomerType){
		String sReturnValue = "";
		if("03".equals(sCustomerType) || "03"==sCustomerType){
			
		}else{
			try{
				BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_TEL");
				BizObject bo = bm.createQuery(" ISNEW='1' and CustomerID=:CustomerID and TelType='E00002' ").setParameter("CustomerID",sCustomerId).getSingleResult(false); 
				if(bo == null){
					sReturnValue = "";
				}else{
					sReturnValue = bo.getAttribute("OWNER").getString();
				}

				if(StringX.isEmpty(sReturnValue)||"null".equals(sReturnValue)||"null"==sReturnValue){
					 sReturnValue = "";
				}else{
					//sReturnValue = sReturnValue.replace("null", "");
				}
			}catch(Exception e){
				e.printStackTrace();
			}
			return sReturnValue;
		}
		return sReturnValue;
	}

	/**
	 * 获取法人代表
	 * @param sCustomerId
	 * @param sCustomerType
	 * @return
	 */
	public static String getEntPersoner(String sCustomerId,String  sCustomerType){
		String sReturnValue = "";
		String sRelativeType = "";
		StringBuffer sReturnValues = new StringBuffer();
		if("03".equals(sCustomerType) || "03"==sCustomerType){
			//sRelativeType="1022";
		}else{
			sRelativeType="1001";
		}
		
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_RELATIVE");
			List<BizObject> lst=bm.createQuery("customerid='"+sCustomerId+"' and RelationShip='"+sRelativeType+"'").getResultList(false); 
			for(BizObject bo:lst){
				sReturnValues.append(bo.getAttribute("RELATIVECUSTOMERNAME").getString()).append(",");	
			}
			
			if(StringX.isEmpty(sReturnValues.toString())||"null".equals(sReturnValues.toString())||"null"==sReturnValues.toString()){
				 sReturnValue = "";
			}else{
				sReturnValue = sReturnValues.toString().replace("null", "");
				sReturnValue = sReturnValue.substring(0,sReturnValue.length()-1);
			}
		}catch(Exception e){
			e.printStackTrace();
		}

		return sReturnValue;
	}

	/**
	 * 获取联系电话
	 * @param sCustomerId
	 * @param sCustomerType
	 * @return
	 */
	public static String getNorTel(String sCustomerId,String  sCustomerType){
		String sReturnValue = "";
		String sTelType = "";
		StringBuffer sReturnValues = new StringBuffer();
		if("03".equals(sCustomerType) || "03"==sCustomerType){
			sTelType="PB2004";
		}else{
			sTelType="E00001";
		}
		
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.customer.CUSTOMER_TEL");
			List<BizObject> lst=bm.createQuery(" ISNEW='1' and customerid='"+sCustomerId+"' and telType='"+sTelType+"'").getResultList(false); 
			for(BizObject bo:lst){
				sReturnValues.append(bo.getAttribute("TELEPHONE").getString()).append(",");	
			}
			
			if(StringX.isEmpty(sReturnValues.toString())||"null".equals(sReturnValues.toString())||"null"==sReturnValues.toString()){
				 sReturnValue = "";
			}else{
				sReturnValue = sReturnValues.toString().replace("null", "");
				sReturnValue = sReturnValue.substring(0,sReturnValue.length()-1);
			}
		}catch(Exception e){
			e.printStackTrace();
		}

		return sReturnValue;
	}

	/**
	 * 获取所在地址
	 * @param sCustomerId
	 * @param sCustomerType
	 * @return
	 */
	public static String getNorAddress(String sCustomerId,String  sCustomerType){
		String sReturnValue = "";
		String sAddressType = "";
		StringBuffer sReturnValues = new StringBuffer();
		if("03".equals(sCustomerType) || "03"==sCustomerType){
			sAddressType="01";
		}else{
			sAddressType="08";
		}
		
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.PUB_ADDRESS_INFO");
			List<BizObject> lst=bm.createQuery(" ISNEW='1' and  objectno='"+sCustomerId+"' and objectType='jbo.customer.CUSTOMER_INFO' and addressType='"+sAddressType+"'").getResultList(false); 
			for(BizObject bo:lst){
				sReturnValues.append(bo.getAttribute("ADDRESS1").getString()).append(" ").append(bo.getAttribute("ADDRESS2").getString()).append(",");	
			}
			
			if(StringX.isEmpty(sReturnValues.toString())||"null".equals(sReturnValues.toString())||"null"==sReturnValues.toString()){
				 sReturnValue = "";
			}else{
				sReturnValue = sReturnValues.toString().replace("null", "");
				sReturnValue = sReturnValue.substring(0,sReturnValue.length()-1);
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		sReturnValue = sReturnValue.replace("null", "");
		return sReturnValue;
	}
	

	/**
	 * 获取所在地址邮编
	 * @param sCustomerId
	 * @param sCustomerType
	 * @return
	 */
	public static String getNorZIP(String sCustomerId,String  sCustomerType){
		String sReturnValue = "";
		String sAddressType = "";
		StringBuffer sReturnValues = new StringBuffer();
		if("03".equals(sCustomerType) || "03"==sCustomerType){
			sAddressType="01";
		}else{
			sAddressType="08";
		}
		
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.app.PUB_ADDRESS_INFO");
			List<BizObject> lst=bm.createQuery(" ISNEW='1' and objectno='"+sCustomerId+"' and objectType='jbo.customer.CUSTOMER_INFO' and addressType='"+sAddressType+"'").getResultList(false); 
			for(BizObject bo:lst){
				sReturnValues.append(bo.getAttribute("ZIPCODE").getString()).append(",");	
			}
			
			if(StringX.isEmpty(sReturnValues.toString())||"null".equals(sReturnValues.toString())||"null"==sReturnValues.toString()){
				 sReturnValue = "";
			}else{
				sReturnValue = sReturnValues.toString().replace("null", "");
				sReturnValue = sReturnValue.substring(0,sReturnValue.length()-1);
			}
		}catch(Exception e){
			e.printStackTrace();
		}

		return sReturnValue;
	}


	@SuppressWarnings("null")
	public static String getExpiateaMount(String sDASerialNo){
		String sReturnValue = "";
		try{
			BizObjectManager bm=JBOFactory.getBizObjectManager("jbo.preservation.NPA_DEBTASSET_OBJECT");
			BizObject bo = bm.createQuery("select sum(EXPIATEAMOUNT) from O where  Debtassetserialno='"+sDASerialNo+"' and objectType in('jbo.preservation.LAWCASE_INFO','Business_Contract')  ").getSingleResult(false); 
			if(bo == null){
				sReturnValue = "0.00";
			}else{
				sReturnValue = String.valueOf(bo.getAttribute(14).getDouble());
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		return sReturnValue;
	}

}
