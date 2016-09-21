package com.amarsoft.app.als.customer.model;

import java.util.Map;

import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.dict.als.manage.CodeManager;
import com.amarsoft.dict.als.object.Item;

/**
 * 客户对象
 * <li>包含客户的基本功能
 * @author cjyu
 *
 */
public class CustomerInfo {

	private BizObject boCustomerInfo;
	private BizObject boEntOrInd;
	private BizObjectManager bm;
	private BizObjectManager bmEntOrInd;
	private String customerID="";
	private String customerType="";
	private JBOTransaction tran;
	/**
	 * 初始化客户对象
	 * @param tx
	 * @param customerID
	 * @throws JBOException 
	 */
	public CustomerInfo(JBOTransaction tx,String customerID) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_INFO);
		if(tx!=null){
			tx.join(bm);
			tran=tx;
		}
		if(customerID!=null){
			boCustomerInfo=bm.createQuery("CustomerID=:customerID").setParameter("customerID", customerID).getSingleResult(tx!=null);
			this.customerID=customerID;
			customerType=boCustomerInfo.getAttribute("CustomerType").getString();
		}
	}
	
	
	/**
	 * 初始化客户对象
	 * @param tx
	 * @param customerID
	 * @throws JBOException 
	 */
	public   CustomerInfo  (JBOTransaction tx,String natureCode,String certType,String certid) throws JBOException{
		bm=JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_INFO);
		if(tx!=null){
			tx.join(bm);
			tran=tx;
		}
			boCustomerInfo=bm.createQuery("CertID=:certId and CertType=:certType and issueCountry=:nationCode")
							.setParameter("certId", certid)
							.setParameter("certType", certType)
							.setParameter("nationCode", natureCode)
							.getSingleResult(tx!=null);
			if(boCustomerInfo!=null){
				customerType=boCustomerInfo.getAttribute("CustomerType").getString();
				this.customerID=boCustomerInfo.getAttribute("customerID").getString();
				
			}
	}
	
	/**
	 * 获得客户对象
	 * @return
	 */
	public BizObject getBizObject(){
		return boCustomerInfo;
	}
	/**
	 * 获得客户信息表属性
	 * @param attributeIndex
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributeIndex) throws JBOException{
		return boCustomerInfo.getAttribute(attributeIndex);
	}
	/**
	 * 设置数据
	 * @param attributeName
	 * @param value
	 * @throws JBOException
	 */
	public void setAttribute(String attributeName,Object value) throws JBOException{
		boCustomerInfo.setAttributeValue(attributeName, value);
		
	}
	/**
	 * 保存
	 * @param CustomerType
	 * @param userId
	 * @param map
	 * @return
	 * @throws Exception
	 */
	public BizObject newCustomer(String CustomerType,String userId,Map map) throws Exception{
		if(this.boCustomerInfo!=null) throw new Exception("客户["+customerID+"]存在，不能在新增!");
		this.customerType=CustomerType;
		initEntOrIndManage(); 
		boCustomerInfo=this.bm.newObject();
		boCustomerInfo.setAttributesValue(map);
		this.boEntOrInd=this.bmEntOrInd.newObject();
		boEntOrInd.setAttributesValue(map);
		setIndOrEntAttribute("ENTERPRISENAME", boCustomerInfo.getAttribute("CustomerName"));
		setIndOrEntAttribute("FULLNAME", boCustomerInfo.getAttribute("CustomerName"));
		setIndOrEntAttribute("COUNTRY", boCustomerInfo.getAttribute("issueCountry"));
		boEntOrInd.setAttributesValue(map);
		this.bm.saveObject(this.boCustomerInfo);
		boEntOrInd.setAttributesValue(boCustomerInfo);
		 this.bmEntOrInd.saveObject(boEntOrInd);
		this.customerID=this.boCustomerInfo.getAttribute("CustomerID").getString();
		CustomerBelong cb=new CustomerBelong(this.tran,customerID,userId);//建立客户权限信息
/*		cb.setApplyRight(CustomerConst.HAVENO_1);
		cb.setManageRight(CustomerConst.HAVENO_1);
		cb.setModifyRight(CustomerConst.HAVENO_1);
		cb.setViewyRight(CustomerConst.HAVENO_1);*/
		cb.saveBelong();
		
		 CustomerCert cc = new CustomerCert(this.tran,"");//在证件信息表中增加
		 map.put("ISSUECOUNTRY", this.boCustomerInfo.getAttribute("issueCountry").toString());
		 map.put("CUSTOMERID", customerID);
		 map.put("Status", CustomerConst.CUSTOMER_IDENTITY_STATUS_1);
		 map.put("MainFlag", CustomerConst.CUSTOMER_IDENTITY_MAINFLAG_1);
		   //新增证件信息 
		 cc.newCustomerCert(map);
		   
		return boCustomerInfo;
	}
	
	private void setIndOrEntAttribute(String colname,DataElement de) throws JBOException{
		if(boEntOrInd==null) return ;
		if(boEntOrInd.indexOfAttribute(colname)>0){
			this.boEntOrInd.setAttributeValue(colname, de);
		}
	}
	
	private void initEntOrIndManage() throws JBOException{
		if(bmEntOrInd!=null) return ;
		if(this.customerType.startsWith(CustomerConst.CustomerType_01) ||this.customerType.startsWith(CustomerConst.CUSTOMERTYPE_ALIKE)){//公司公司
			bmEntOrInd=JBOFactory.getBizObjectManager(CustomerConst.ENT_INFO);
		}else if(this.customerType.startsWith(CustomerConst.CustomerType_03)){//个人
			bmEntOrInd=JBOFactory.getBizObjectManager(CustomerConst.IND_INFO);
		}
		if(bmEntOrInd==null) throw new JBOException("客户编号["+customerID+"]的客户类型未知");
	}
	
	/**
	 * 初始化INDOrEnt对象
	 * @throws JBOException
	 */
	private void  initEntOrInd() throws JBOException{
		initEntOrIndManage();
		if(tran!=null)tran.join(bmEntOrInd);
		this.boEntOrInd=bmEntOrInd.createQuery("CustomerID=:customerID").setParameter("customerID", this.customerID).getSingleResult(tran!=null);
	}
	/**
	 * 保存客户信息
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		this.bm.saveObject(this.boCustomerInfo);
		if(this.bmEntOrInd!=null) this.bmEntOrInd.saveObject(this.boEntOrInd);
	}
	
	public String getString(String attributeName) throws JBOException{
		String attribute="";
		if(this.boCustomerInfo.indexOfAttribute(attributeName)>0){
			attribute=this.boCustomerInfo.getAttribute(attributeName).getString();
		}else{
			if(boEntOrInd==null) initEntOrInd();
			if(boEntOrInd.indexOfAttribute(attributeName)>0) attribute=boEntOrInd.getAttribute(attributeName).getString();
		}
		if(attribute==null) attribute="";
		return attribute;
	}
	
	public String getCustomerInfoTemplet() throws Exception{
		////公司客户
		String templetNo="";
		if(this.customerType.startsWith(CustomerConst.CustomerType_01)){
			String sCustomerOrgType=this.getString("OrgNature");
			Item item=CodeManager.getItem("CustomerOrgType", sCustomerOrgType);
			if(item!=null){
				if(this.customerType.equals("0120"))
				{
					templetNo=item.getAttribute3();
				}else{
					templetNo=item.getItemAttribute();
				}
			}
			if(templetNo.equals("")) templetNo="EnterpriseInfo03";
		}else{
			Item item=CodeManager.getItem("CustomerType", customerType);
			if(item!=null)  templetNo=item.getItemAttribute();
			if(templetNo.equals("")) templetNo="Individual";
		}
		return templetNo;
	}
}
