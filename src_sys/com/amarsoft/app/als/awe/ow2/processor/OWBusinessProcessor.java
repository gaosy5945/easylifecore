package com.amarsoft.app.als.awe.ow2.processor;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.als.awe.ow2.config.ObjectWindowFactory;
import com.amarsoft.app.als.awe.ow2.manager.ObjectWindowManager;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.exception.ALSException;
import com.amarsoft.app.base.util.AmarScriptHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.base.util.SystemHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectClass;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.are.sql.SQLConstants;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.RuntimeContext;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.handler.AbBusinessProcess;
import com.amarsoft.awe.dw.handler.BusinessProcessData;

/**
 * 传统的OW直接将数据保存至数据库，缺少中间业务逻辑的处理，该类用于接管原业务处理逻辑，默认不会保存至数据库，所有处理将转至外部业务逻辑处理。
 * @author ygwang
 */
public class OWBusinessProcessor extends AbBusinessProcess{
	public static final String DEFAULT_SAVE_CLASSNAME="com.amarsoft.app.als.awe.ow2.processor.impl.DefaultSaver";
	public static final String DEFAULT_DELETE_CLASSNAME="com.amarsoft.app.als.awe.ow2.processor.impl.DefaultDeleter";
	public static final String DEFAULT_CREATE_CLASSNAME="com.amarsoft.app.als.awe.ow2.processor.impl.DefaultCreator";
	public static final String DEFAULT_QUERY_CLASSNAME="com.amarsoft.app.als.awe.ow2.processor.impl.DefaultInfoQuerier";
	
	protected JBOTransaction transaction;
	protected BusinessObjectManager bomanager;
	protected ObjectWindowManager owmanager;
	
	public ObjectWindowManager getOWManager() {
		return owmanager;
	}

	/* 
	 * 未使用
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#addCustomize(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	public final boolean addCustomize(BusinessProcessData bpdata) throws Exception {
		return true;
	}
	
	public final Page getPage() throws Exception {
		return this.asPage;
	}
	
	/* 
	 * 未使用
	 * (non-Javadoc)
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#defaultAction(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	public final boolean defaultAction(BusinessProcessData bpdata) throws Exception {
		return false;
	}
	
	/* 
	 * 未使用
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#addCustomize(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	public final void setManager(BizObjectManager manager) {
	}
	
	/* 
	 * 未使用
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#addCustomize(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	public final void setTransaction(JBOTransaction transaction) {
		this.transaction = transaction;
	}
	
	/* 
	 * 未使用
	 * (non-Javadoc)
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#editCustomize(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	public final boolean editCustomize(BusinessProcessData bpdata) throws Exception {
		return true;
	}
	
	/*
	 * 未使用
	 *  (non-Javadoc)
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#getOriginalValues()
	 */
	public final Map<BizObject, Map<String, Object>> getOriginalValues() {
		return new HashMap<BizObject,Map<String, Object>>();
	}
	
	private String getBPActionClassName(String action,String defaultClassName) throws Exception{
		BusinessObject bpConfig = owmanager.getObjectWindowConfig().getBusinessObject("businessProcessor");
		if(bpConfig==null) return defaultClassName;
		BusinessObject actionConfig = bpConfig.getBusinessObjectByKey("actions", action);
		String className = actionConfig.getString("classname");
		if(StringX.isEmpty(className)) return defaultClassName;
		else return className;
	}
	
	public DataObjectSaver getSaver() throws Exception{
		String className = getBPActionClassName("save",DEFAULT_SAVE_CLASSNAME);
		Class<?> proceesorClass = Class.forName(className);
		DataObjectSaver proceesor = (DataObjectSaver)proceesorClass.newInstance();
		return proceesor;
	}
	
	public DataObjectDeleter getDeleter() throws Exception{
		String className = getBPActionClassName("delete",DEFAULT_DELETE_CLASSNAME);
		Class<?> proceesorClass = Class.forName(className);
		DataObjectDeleter proceesor = (DataObjectDeleter)proceesorClass.newInstance();
		return proceesor;
	}
	
	public DataObjectQuerier getQuerier() throws Exception{
		String className = getBPActionClassName("query",DEFAULT_QUERY_CLASSNAME);
		Class<?> proceesorClass = Class.forName(className);
		DataObjectQuerier proceesor = (DataObjectQuerier)proceesorClass.newInstance();
		return proceesor;
	}
	
	public DataObjectCreator getCreator() throws Exception{
		String className = getBPActionClassName("new",DEFAULT_CREATE_CLASSNAME);
		Class<?> proceesorClass = Class.forName(className);
		DataObjectCreator proceesor = (DataObjectCreator)proceesorClass.newInstance();
		return proceesor;
	}
	
	@Override
	public final boolean query(BusinessProcessData businessprocessdata)throws Exception {
		return false;
	}
	
	/* 
	 * 保存操作
	 * (non-Javadoc)
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#save(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	public final boolean save(BusinessProcessData bpdata) throws Exception {
		boolean result=true;
		if(transaction==null) transaction = JBOFactory.getFactory().createTransaction();
		bomanager = BusinessObjectManager.createBusinessObjectManager(transaction);
		try{
			for(int i=0;i<this.jbos.length;i++){
				BusinessObject businessObject = (BusinessObject)jbos[i];
				jbos[i]=this.getSaver().save(businessObject, this);
				bomanager.updateDB();
			}
			bomanager.updateDB();
			return result;
		} 
		catch (Exception e) {
			result= false;
			e.printStackTrace();
			this.errors = e.getMessage();
			return result;
		}
		finally{
			if(result){
				if(transaction!=null) transaction.commit();
			}
			else{
				if(transaction!=null) transaction.rollback();
			}
		}
	}
	
	/* 
	 * 删除操作
	 * (non-Javadoc)
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#delete(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	public boolean delete(BusinessProcessData bpdata) throws Exception {
		boolean result=true;
		if(jbos==null||jbos.length==0) return false;
		try {
			if(transaction==null)
				transaction = JBOFactory.getFactory().createTransaction();
			//设置审计的环境AppContext
			transaction.setAppContext(this.getAppContext());
			bomanager = BusinessObjectManager.createBusinessObjectManager(transaction);
			for(int i=0;i<this.jbos.length;i++){
				BusinessObject businessObject = (BusinessObject)jbos[i];
				this.getDeleter().delete(businessObject, this);
			}
			if(result) bomanager.updateDB();
			return result;
		}
		catch (Exception e) {
			result = false;
			e.printStackTrace();
			this.errors = e.getMessage();
			return result;
		}
		finally{
			if(result){
				if(transaction!=null) transaction.commit();
			}
			else{
				if(transaction!=null) transaction.rollback();
			}
		}
	}
	
	public BusinessObjectManager getBusinessObjectManager(){
		return this.bomanager;
	}
	
	/**
	 * 获取ow的传入参数值
	 * @param doTemp
	 * @param parameterID
	 * @return
	 * @throws Exception 
	 */
	public BusinessObject getInputParameters() throws Exception{
		BusinessObject doTempParameterMap = BusinessObject.createBusinessObject("InputParameter");
		List<DataElement> doTempParameterList = getASDataObject().getParameters();
		if(doTempParameterList==null||doTempParameterList.isEmpty()) return doTempParameterMap;
		for(DataElement parameter:doTempParameterList){
			doTempParameterMap.setAttributeValue(parameter.getName(), parameter.getValue());
		}
		return doTempParameterMap;
	}
	
	/**
	 * 赋默认值
	 * @param businessObject
	 * @throws Exception
	 */
	public void setDefaultValue(BusinessObject dataObjectValues) throws Exception{
		BusinessObject inputParameters=getInputParameters();
		BusinessObject systemParameters=SystemHelper.getSystemParameters(curUser, curUser.getBelongOrg());
		
		//初始化赋值
		for(int i=0;i<asDataObject.Columns.size();i++){
			ASColumn column = asDataObject.getColumn(i);
			String colName = column.getItemName();
			
			String defaultValue = column.getAttribute("COLDEFAULTVALUE");
			if(!StringX.isEmpty(defaultValue)){
				Object value = dataObjectValues.getObject(colName);
				if(value==null||"".equals(value)){
					defaultValue=StringHelper.replaceStringFullName(defaultValue, inputParameters);
					defaultValue=StringHelper.replaceStringFullName(defaultValue, systemParameters);
					defaultValue=StringHelper.replaceString(defaultValue, dataObjectValues);
					if(StringX.isEmpty(defaultValue)&&column.getAttribute("COLDEFAULTVALUE").indexOf(AmarScriptHelper.SCRIPT_PARAMETER_STRING_START)>=0)
						defaultValue="";
					dataObjectValues.setAttributeValue(colName,defaultValue);
				}
			}
		}
	}
	
	/**
	 * 根据显示模板获得扩展后的BizObjectClass
	 * @param dataObject
	 * @return
	 * @throws JBOException
	 */
	public BizObjectClass getDataObjectClass() throws Exception {
		BusinessObject owconfig=owmanager.getObjectWindowConfig();
		BizObjectClass bizObjectClass = new BizObjectClass(asDataObject.getDONO());
		
		List<BusinessObject> owattributes = owconfig.getBusinessObjects("attributes");
		for(int i=0;i<owattributes.size();i++){
			BusinessObject attribute=owattributes.get(i);
			String name=attribute.getString("name");
			byte type=SQLConstants.getBaseDataType(attribute.getString("type"));
			DataElement dataElement = new DataElement(name,type);
			bizObjectClass.addAttribute(dataElement);
		}
		return bizObjectClass;
	}

	/*public BusinessObject convertQueryObject(String objectName,BusinessObject queryObject) throws Exception{
		BusinessObject dataObjectValues = BusinessObject.createBusinessObject(getDataObjectClass());
		BusinessObject owconfig=owmanager.getObjectWindowConfig();
		List<BusinessObject> owattributes = owconfig.getListValue("attributes");
		for(BusinessObject attribute:owattributes){
			String attributeID=attribute.getString("name");
			Object value = null;
			String datasource=attribute.getString("query.value");
			if(datasource.isEmpty()){
				throw new Exception("数据对象{"+asDataObject.getDONO()+"}的属性{"+attributeID+"}未指定query.value值！");
			}
			else if(datasource.indexOf(".")<=0){
				throw new Exception("数据对象{"+asDataObject.getDONO()+"}的属性{"+attributeID+"}指定query.value值未明确对象别名，格式示例xx.yyyy！");
			}
			else{
				String[] s=datasource.split(".");
				BusinessObject subObject = queryObject.getBusinessObjectValue(s[0]);
				value=subObject.getObject(s[1]);
			}
			dataObjectValues.setAttributeValue(attributeID, value);
		}
		dataObjectValues.changeState(businessObject.getState());
		return dataObjectValues;
	}*/
	
	public BusinessObject convertToBusinessObject(BusinessObject dataObjectValues) throws Exception{

		BusinessObject owmanagerConfig = owmanager.getObjectWindowConfig().getBusinessObject("manager");
		String bizObjectClass=owmanagerConfig.getString("mainBizObjectClass");
		BusinessObject businessObject = BusinessObject.createBusinessObject(bizObjectClass);

		List<BusinessObject> owattributes = owmanager.getObjectWindowConfig().getBusinessObjects("attributes");
		for(BusinessObject attribute:owattributes){
			String attributeID=attribute.getString("name");
			Object value = dataObjectValues.getString(attributeID);
			String datasource=attribute.getString("datasource");
			if(datasource.isEmpty()){
				if(businessObject.containsAttribute(attributeID)){
					businessObject.setAttributeValue(attributeID, value);
				}
			}
			else if(datasource.indexOf(".")<=0){
				if(businessObject.containsAttribute(datasource)){
					businessObject.setAttributeValue(datasource, value);
				}
			}
			else{
				String[] s=datasource.split(".");
				BusinessObject subObject = businessObject.getBusinessObject(s[0]);
				if(subObject==null){
					BusinessObject owbizObjectConfig=owmanagerConfig.getBusinessObjectByKey("bizObjects", s[0]);
					String type = owbizObjectConfig.getString("type");
					if(!type.equalsIgnoreCase("JBO")) continue;
					String subObjectClass = owbizObjectConfig.getString("classname");
					if(StringX.isEmpty(subObjectClass)) throw new Exception("数据对象{"+asDataObject.getDONO()+"}下bizObject-classname不允许为空！");
					subObject=BusinessObject.createBusinessObject(subObjectClass);
					businessObject.setAttributeValue(s[0], subObject);
				}
				subObject.setAttributeValue(s[1], value);
			}
		}
		businessObject.changeState(dataObjectValues.getState());
		return businessObject;
	}
	
	/**
	 * 创建一个处理器，指定事务处理
	 * @param request
	 * @param dataObject
	 * @param transaction
	 * @return
	 * @throws Exception
	 */
	public static OWBusinessProcessor createBusinessProcess(HttpServletRequest request,ASDataObject dataObject,BusinessObjectManager bomanager) throws Exception{
		String className = dataObject.getBusinessProcess();
		if(StringX.isEmpty(className)){
			className = "com.amarsoft.app.als.awe.ow2.processor.DefaultBusinessProcess";
		}
		Class<?> businessProcessClass = Class.forName(className);
		OWBusinessProcessor businessProcess = (OWBusinessProcessor)businessProcessClass.newInstance();
		businessProcess.setRequest(request);
		businessProcess.setTransaction(bomanager.getTx());
		businessProcess.bomanager=bomanager;
		businessProcess.owmanager=ObjectWindowFactory.getFactory().getObjectWindowManager(dataObject.getDONO());
		
		businessProcess.setASDataObject(dataObject);
		businessProcess.setCurUser(((RuntimeContext)request.getSession().getAttribute("CurARC")).getUser());
		businessProcess.setConfigure(Configure.getInstance(request.getSession().getServletContext()));
		return businessProcess;
	}

}
