package com.amarsoft.app.als.customer.model;

import java.util.List;

import com.amarsoft.app.als.customer.common.action.CustomerBelongChangeLog;
import com.amarsoft.app.util.ASUserObject;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.util.StringFunction;

/**
 * 客户权限对象类
 * @author wmZhu
 *
 */
public class CustomerBelong {
	
	private String customerID;
	private String orgID;
	private String userID;
	private String manageRight = "2";//管护权 (BelongAttribute)默认都为无
	private String viewyRight = "2";//信息查看权(BelongAttribute1)
	private String modifyRight = "2";//信息维护权 (BelongAttribute2)
	private String applyRight = "2";//业务申办权 (BelongAttribute3)
	private String inputUserID;
	private String inputOrgID;
	private String inputDate;
	
	private BizObjectManager bom = null;
	private BizObject bizObject;
	private List<BizObject> listBelong;
	private JBOTransaction tx = null;
	
	/**
	 * 对象入口
	 * 如果只需要查看而不需要修改,则参数tx为空即可
	 * 如果要查看客户下所有用户拥有的权限则userID为空
	 * @param tx
	 * @param customerID 客户编号
	 * @param userID 用户编号
	 * @throws JBOException
	 */
	public CustomerBelong(JBOTransaction tx,String customerID,String userID) throws JBOException{
		this.tx = tx;
		this.customerID = customerID;
		this.userID = userID;
		init();
	}
	
	/**
	 * 初始化权限对象
	 * @param tx
	 * @throws JBOException
	 */
	@SuppressWarnings({ "unchecked"})
	private void init() throws JBOException{
		bom = JBOFactory.getBizObjectManager(CustomerConst.CUSTOMER_BELONG);
		boolean updateFlag = false;//是否更新标识
		if(tx != null){
			tx.join(bom);
			updateFlag = true;
		}
		if(StringX.isEmpty(this.userID)){//用户为空时,查询客户下所有管护记录
			listBelong = bom.createQuery("CustomerID=:customerID").setParameter("customerID", this.customerID).getResultList(updateFlag);
		}else{
			bizObject = bom.createQuery("CustomerID=:customerID and UserID=:userID")
						.setParameter("customerID", this.customerID).setParameter("UserID", this.userID)
						.getSingleResult(updateFlag);
			//初始化对象属性
			if(bizObject != null){
				this.customerID = bizObject.getAttribute("CustomerID").getString();
				this.userID = bizObject.getAttribute("UserID").getString();
				this.orgID = bizObject.getAttribute("OrgID").getString();
				this.manageRight = bizObject.getAttribute("BelongAttribute").getString();
				this.viewyRight = bizObject.getAttribute("BelongAttribute1").getString();
				this.modifyRight = bizObject.getAttribute("BelongAttribute2").getString();
				this.applyRight = bizObject.getAttribute("BelongAttribute3").getString();
				this.inputUserID = bizObject.getAttribute("InputUserID").getString();
				this.inputOrgID = bizObject.getAttribute("InputOrgID").getString();
				this.inputDate = bizObject.getAttribute("InputDate").getString();
			}
		}
	}
	/**
	 * 保存管理记录
	 * @throws Exception 
	 */
	@SuppressWarnings("deprecation")
	public void saveBelong() throws Exception{
		//客户变更记录对象
		CustomerBelongChangeLog cbc = new CustomerBelongChangeLog();
		ASUserObject ao = ASUserObject.getUser(this.userID);
		this.orgID = ao.getOrgID();//初始化机构编号
		
		if(bizObject == null){
			bizObject = bom.newObject();
			bizObject.setAttributeValue("InputDate", StringFunction.getToday());
			bizObject.setAttributeValue("InputUserID", this.inputUserID);
			bizObject.setAttributeValue("InputOrgID", this.inputOrgID);
			
			/*//创建引入记录
			cbc.createImportLog(tx, customerID, this.userID,this.orgID);*/
		}
		/*if(CustomerConst.HAVENO_1.equals(this.manageRight)){//拥有管护权时,创建管护人变更记录
			cbc.createManageChangeLog(tx, customerID, this.userID, this.orgID);
		}*/
		bizObject.setAttributeValue("CustomerID", this.customerID);
		bizObject.setAttributeValue("UserID", this.userID);
		bizObject.setAttributeValue("OrgID",this.orgID);
		bizObject.setAttributeValue("BelongAttribute", this.manageRight);
		bizObject.setAttributeValue("BelongAttribute1", this.viewyRight);
		bizObject.setAttributeValue("BelongAttribute2", this.modifyRight);
		bizObject.setAttributeValue("BelongAttribute3", this.applyRight);
		bom.saveObject(bizObject);
	}
	/**
	 * 删除管理记录
	 * @throws JBOException
	 */
	public void deleteBelong() throws JBOException{
		bom.deleteObject(bizObject);
	}
	
	/**
	 * 获取管护人与管护机构
	 * @return 返回一个数组,如果管护人不存在则该数组为空
	 * @throws JBOException 
	 */
	@SuppressWarnings("unchecked")
	public String[] getManageUser() throws JBOException{
		String[] manage = null;
		if(listBelong == null){
			listBelong = bom.createQuery("CustomerID=:customerID").setParameter("customerID", this.customerID).getResultList(false);
		}
		BizObject biz = null;
		for(int i=0;i<listBelong.size();i++){
			biz = listBelong.get(i);
			if("1".equals(biz.getAttribute("BelongAttribute").getString())){
				manage = new String[2];
				manage[0] = biz.getAttribute("UserID").getString();
				manage[1] = biz.getAttribute("OrgID").getString();
				break;
			}
		}
		return manage;
	}
	
	/**
	 * 获得客户所属表属性
	 * @param attributeIndex
	 * @return
	 * @throws JBOException
	 */
	public DataElement getAttribute(String attributeIndex) throws JBOException{
		return bizObject.getAttribute(attributeIndex);
	}
	
	/**
	 * 设置数据
	 * @param attributeName
	 * @param value
	 * @throws JBOException
	 */
	public void setAttribute(String attributeName,Object value) throws JBOException{
		bizObject.setAttributeValue(attributeName, value);
		
	}

	/**
	 * 保存客户权属信息
	 * @throws JBOException 
	 */
	public void saveObject() throws JBOException{
		this.bom.saveObject(this.bizObject);
	}
	
	/**
	 * 判断是否有其他客户经理已具有该客户的主办权
	 * @throws JBOException 
	 */
	public BizObject getBelongAttribute(JBOTransaction tx,String customerID,String userID) throws JBOException{
		this.customerID = customerID;
		this.userID= userID;
		this.bizObject = bom.createQuery("CustomerID=:customerID and UserID<>:userID and BelongAttribute=:belongAttribute").
				setParameter("customerID", customerID).setParameter("userID", userID).
				setParameter("belongAttribute", CustomerConst.CUSTOMER_BELONG_BELONGATTRIBUTE_1).getSingleResult(tx!=null);
		return bizObject;
	}

	
	public String getCustomerID() {
		return customerID;
	}
	public String getOrgID() {
		return orgID;
	}
	public String getUserID() {
		return userID;
	}
	public String getManageRight() {
		return manageRight;
	}
	public void setManageRight(String manageRight) {
		this.manageRight = manageRight;
	}
	public String getViewyRight() {
		return viewyRight;
	}
	public void setViewyRight(String viewyRight) {
		this.viewyRight = viewyRight;
	}
	public String getModifyRight() {
		return modifyRight;
	}
	public void setModifyRight(String modifyRight) {
		this.modifyRight = modifyRight;
	}
	public String getApplyRight() {
		return applyRight;
	}
	public void setApplyRight(String applyRight) {
		this.applyRight = applyRight;
	}
	public String getInputUserID() {
		return inputUserID;
	}
	public void setInputUserID(String inputUserID) {
		this.inputUserID = inputUserID;
	}
	public void setInputOrgID(String inputOrgID) {
		this.inputOrgID = inputOrgID;
	}
	public String getInputOrgID() {
		return inputOrgID;
	}
	public String getInputDate() {
		return inputDate;
	}
	public BizObject getBizObject(){
		return bizObject;
	}
	public List<BizObject> getListBelong() {
		return listBelong;
	}
}
