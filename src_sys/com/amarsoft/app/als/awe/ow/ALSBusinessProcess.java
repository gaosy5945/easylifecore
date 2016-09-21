package com.amarsoft.app.als.awe.ow;
import java.net.URLDecoder;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.Iterator;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWCreator;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWDeleter;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWQuerier;
import com.amarsoft.app.als.awe.ow.processor.BusinessObjectOWUpdater;
import com.amarsoft.app.base.businessobject.BusinessObject;
import com.amarsoft.app.base.businessobject.BusinessObjectManager;
import com.amarsoft.app.base.util.AmarScriptHelper;
import com.amarsoft.app.base.util.JBOHelper;
import com.amarsoft.app.base.util.JavaMethodHelper;
import com.amarsoft.app.base.util.ObjectWindowHelper;
import com.amarsoft.app.base.util.StringHelper;
import com.amarsoft.app.base.util.SystemHelper;
import com.amarsoft.are.jbo.BizObject;
import com.amarsoft.are.jbo.BizObjectManager;
import com.amarsoft.are.jbo.BizObjectQuery;
import com.amarsoft.are.jbo.JBOException;
import com.amarsoft.are.jbo.JBOFactory;
import com.amarsoft.are.jbo.JBOTransaction;
import com.amarsoft.are.jbo.impl.StateBizObject;
import com.amarsoft.are.lang.DataElement;
import com.amarsoft.are.lang.StringX;
import com.amarsoft.awe.Configure;
import com.amarsoft.awe.RuntimeContext;
import com.amarsoft.awe.control.model.Page;
import com.amarsoft.awe.dw.ASColumn;
import com.amarsoft.awe.dw.ASDataObject;
import com.amarsoft.awe.dw.ASDataObjectFilter;
import com.amarsoft.awe.dw.handler.AbBusinessProcess;
import com.amarsoft.awe.dw.handler.BusinessProcessData;

/**
 * 传统的OW直接将数据保存至数据库，缺少中间业务逻辑的处理，该类用于接管原业务处理逻辑，默认不会保存至数据库，所有处理将转至外部业务逻辑处理。
 * @author ygwang
 *
 */
public class ALSBusinessProcess extends AbBusinessProcess{
	protected JBOTransaction transaction;
	protected BusinessObjectManager bomanager;
	protected BusinessObject outputbject;
	
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
	
	/* 
	 * 未使用
	 * (non-Javadoc)
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#query(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	 
	public final boolean query(BusinessProcessData bpdata) throws Exception {
		return false;
	}
	
	/**
	 * 设置OW的返回参数，如：保存后直接获取对应流水号，后续程序可以直接使用，返回的参数不一定是OW配置的字段
	 * @param bpdata
	 * @param parameterName
	 * @param parameterValue
	 * @throws Exception
	 */
	protected void setOutputParameter(String parameterName,String parameterValue) throws Exception{
		this.outputbject.setAttributeValue(parameterName, parameterValue);
	}
	
	/**
	 * 设置OW的返回参数，如：保存后直接获取对应流水号，后续程序可以直接使用，返回的参数不一定是OW配置的字段
	 * @param bpdata
	 * @param parameterName
	 * @param parameterValue
	 * @throws Exception
	 */
	public final BusinessObject getOutputParameters() throws Exception{
		return this.outputbject;
	}
	
	public final List<BusinessObject> save(BusinessObject o) throws Exception{
		List<BusinessObject> list = new ArrayList<BusinessObject>();
		list.add(o);
		//this.setObjects(subobjectArray);
		return this.save(list);
	}
	
	public List<BusinessObject> save(List<BusinessObject> list) throws Exception{
		for(int i=0;i<list.size();i++){
			BusinessObject businessObject = list.get(i);
			this.setDefaultValue(businessObject);
			businessObject=convertBusinessObject(businessObject);//根据主对象属性，更新附属对象属性
			this.getBusinessObjectUpdater().update(businessObject, this);
			refreshExtendedAttributes(businessObject);//保存操作执行后，再将主对象属性进行同步，保证返给前台是正确的。
		}
		bomanager.updateDB();
		return list;
	}
	
	/* 
	 * 保存操作
	 * (non-Javadoc)
	 * @see com.amarsoft.awe.dw.handler.BusinessProcess#save(com.amarsoft.awe.dw.handler.BusinessProcessData)
	 */
	@SuppressWarnings({ "rawtypes", "unchecked" })
	public final boolean save(BusinessProcessData bpdata) throws Exception {
		boolean result=true;
		if(jbos == null) return true;
		if(bpdata==null)bpdata=new BusinessProcessData();
		if(bpdata.mapData==null)bpdata.mapData= new Hashtable();
		
		BusinessObject outputParameterObject = BusinessObject.createBusinessObject();
		bpdata.mapData.put("SYS_ObjectWindow_OutputParameter",outputParameterObject);
		
		boolean autoCommit=false;
		if(transaction==null){
			transaction = JBOFactory.getFactory().createTransaction();
			autoCommit=true;
		}
		bomanager = BusinessObjectManager.createBusinessObjectManager(transaction);
		try{
			List<BusinessObject> list = new ArrayList<BusinessObject>();
			for(int i=0;i<this.jbos.length;i++){
				BusinessObject businessObject = null;
				if(jbos[i] instanceof BusinessObject){
					businessObject = (BusinessObject)jbos[i];
				}
				else{
					businessObject=BusinessObject.convertFromBizObject(jbos[i]);
				}
				list.add(businessObject);
			}
			List<BusinessObject> processedData=this.save(list);
			for(int i=0;i<processedData.size();i++){
				jbos[i]=processedData.get(i);
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
			if(result){//只有此次创建的链接才提交，其他的不做提交操作
				if(autoCommit) transaction.commit();
			}
			else{
				if(transaction!=null) transaction.rollback();
			}
		}
	}
	
	public List<BusinessObject> delete(List<BusinessObject> list) throws Exception{
		for(int i=0;i<list.size();i++){
			BusinessObject businessObject = list.get(i);
			businessObject=convertBusinessObject(businessObject);//根据主对象属性，更新附属对象属性
			if(businessObject.getState()!=StateBizObject.STATE_NEW){
				this.getBusinessObjectDeleter().delete(businessObject, this);
			}
		}
		bomanager.updateDB();
		return list;
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
			List<BusinessObject> list = new ArrayList<BusinessObject>();
			for(int i=0;i<this.jbos.length;i++){
				BusinessObject businessObject = null;
				if(jbos[i] instanceof BusinessObject){
					businessObject = (BusinessObject)jbos[i];
				}
				else{
					businessObject=BusinessObject.convertFromBizObject(jbos[i]);
				}
				list.add(businessObject);
			}
			this.delete(list);
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
	
	public BusinessObjectOWUpdater getBusinessObjectUpdater() throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		String className = this.asDataObject.getCustomProperties().getProperty("BusinessObjectUpdater");
		if(StringX.isEmpty(className)){
			if(this instanceof BusinessObjectOWUpdater) return (BusinessObjectOWUpdater)this;
			className = "com.amarsoft.app.als.awe.ow.processor.impl.update.DefaultOWUpdater";
		}
		Class<?> proceesorClass = Class.forName(className);
		BusinessObjectOWUpdater proceesor = (BusinessObjectOWUpdater)proceesorClass.newInstance();
		return proceesor;
	}
	
	public BusinessObjectOWDeleter getBusinessObjectDeleter() throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		String className = this.asDataObject.getCustomProperties().getProperty("BusinessObjectDeleter");
		if(StringX.isEmpty(className)){
			if(this instanceof BusinessObjectOWDeleter) return (BusinessObjectOWDeleter)this;
			className = "com.amarsoft.app.als.awe.ow.processor.impl.delete.DefaultOWDeleter";
		}
		Class<?> proceesorClass = Class.forName(className);
		BusinessObjectOWDeleter proceesor = (BusinessObjectOWDeleter)proceesorClass.newInstance();
		return proceesor;
	}
	
	public BusinessObjectOWQuerier getBusinessObjectQuerier() throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		String className = this.asDataObject.getCustomProperties().getProperty("BusinessObjectQuerier");
		if(StringX.isEmpty(className)){
			if(this instanceof BusinessObjectOWQuerier) return (BusinessObjectOWQuerier)this;
			className = "com.amarsoft.app.als.awe.ow.processor.impl.query.DefaultOWQuerier";
		}
		Class<?> proceesorClass = Class.forName(className);
		BusinessObjectOWQuerier proceesor = (BusinessObjectOWQuerier)proceesorClass.newInstance();
		return proceesor;
	}
	
	public BusinessObjectOWCreator getBusinessObjectCreator() throws ClassNotFoundException, InstantiationException, IllegalAccessException{
		String className = this.asDataObject.getCustomProperties().getProperty("BusinessObjectCreator");
		if(StringX.isEmpty(className)){
			if(this instanceof BusinessObjectOWCreator) return (BusinessObjectOWCreator)this;
			className = "com.amarsoft.app.als.awe.ow.processor.impl.create.DefaultOWCreator";
		}
		Class<?> proceesorClass = Class.forName(className);
		BusinessObjectOWCreator proceesor = (BusinessObjectOWCreator)proceesorClass.newInstance();
		return proceesor;
	}
	
	/**
	 * 反向更新JBO的扩展属性
	 * @param businessObject
	 * @return
	 * @throws JBOException
	 * @throws Exception
	 */
	protected int refreshExtendedAttributes(BusinessObject businessObject) throws JBOException, Exception{
		if(StringX.isEmpty(this.asDataObject.getJboFrom())) return 1;//如果不是JBO查询的，则不做任何转换
		Map<String, String> jboClassMap = ObjectWindowHelper.getJBOClassMap(this.asDataObject);
		for(Object o:this.asDataObject.Columns){
			ASColumn ascolumn = (ASColumn)o;
			String jboClassAlias = ascolumn.getAttribute("COLTABLENAME");
			if(StringX.isEmpty(jboClassAlias)) continue;
			if(jboClassAlias.equalsIgnoreCase("O"))  continue;
			
			String jboClassName = jboClassMap.get(jboClassAlias);
			BusinessObject relativeObject =businessObject.getBusinessObject(jboClassName);
			if(relativeObject==null) continue;
			businessObject.setAttributeValue(ascolumn.getAttribute("COLNAME")
					,relativeObject.getObject(ascolumn.getAttribute("COLACTUALNAME")));
		}
		return 1;
	}
	
	/**
	 * 赋默认值
	 * @param businessObject
	 * @throws Exception
	 */
	public void setDefaultValue(BusinessObject businessObject) throws Exception{
		BusinessObject parameters=ObjectWindowHelper.getDataObjectParameters(asDataObject);
		parameters.appendAttributes(SystemHelper.getSystemParameters(curUser, curUser.getBelongOrg()));
		
		//初始化赋值
		for(int i=0;i<this.asDataObject.Columns.size();i++){
			ASColumn column = asDataObject.getColumn(i);
			String colName = column.getItemName();
			
			String defaultValue = column.getAttribute("COLDEFAULTVALUE");
			if(!StringX.isEmpty(defaultValue)){
				Object value = businessObject.getObject(colName);
				if(value==null||"".equals(value)){
					//parameters.setAttributesValue(businessObject);
					String defaultValue1=StringHelper.replaceString(defaultValue, parameters);
					
					if(StringX.isEmpty(defaultValue1)||defaultValue1.indexOf("{#")>=0){
						defaultValue=StringHelper.replaceString(defaultValue, businessObject);
					}
					else defaultValue=defaultValue1;
					if(StringX.isEmpty(defaultValue)&&column.getAttribute("COLDEFAULTVALUE").indexOf(AmarScriptHelper.SCRIPT_PARAMETER_STRING_START)>=0)
						defaultValue="";
					businessObject.setAttributeValue(colName,defaultValue);
				}
			}
		}
		//赋虚拟字段值
		setFunctionValues(businessObject);
	}
	
	/**
	 * 将页面中涉及到的虚拟字段，一般指函数，通过调用java缓存实现
	 * @param businessObject
	 * @throws Exception
	 */
	public void setFunctionValues(BusinessObject businessObject) throws Exception{
		String[] virtualFieldArray = this.asDataObject.getVirtualFields();
		if(virtualFieldArray==null)return;
		
		
		for(String virtualField:virtualFieldArray){
			String value = businessObject.getString(virtualField);
			if(!StringX.isEmpty(value)) continue;
			ASColumn doTempColumn = asDataObject.getColumn(virtualField);
			if(doTempColumn==null || !"1".equals(doTempColumn.getAttribute("ISINUSE"))) continue;
			BusinessObject parameters = SystemHelper.getSystemParameters(curUser, curUser.getBelongOrg());
			parameters.appendAttributes(businessObject);
			//获得取值方法
			String functionName = doTempColumn.getAttribute("COLACTUALNAME");
			Object result = JavaMethodHelper.runStaticMethod(functionName, parameters);
			//将值设置到jbo对象中
			if(result!=null) businessObject.setAttributeValue(doTempColumn.getItemName(), result);
		}
	}
	
	/**
	 * 将业务对象转换为复杂的业务对象
	 * @param businessObject
	 * @param dataObject
	 * @throws Exception
	 */
	public BusinessObject convertBusinessObject(BusinessObject businessObject) throws Exception{
		if(StringX.isEmpty(this.asDataObject.getJboFrom())) return businessObject;//如果不是JBO查询的，则不做任何转换
		Map<String, String> needUpdateJBOClassMap = ObjectWindowHelper.getNeedUpdateJBOClass(this.asDataObject);
		for(Iterator<String> it=needUpdateJBOClassMap.keySet().iterator();it.hasNext();){
			String jboClassAlias = it.next();
			String jboClassName = needUpdateJBOClassMap.get(jboClassAlias);
			BusinessObject relativeObject =businessObject.getBusinessObject(jboClassName);
			if(relativeObject==null){
				relativeObject = BusinessObject.createBusinessObject(jboClassName);
			}
			
			for(Object o:asDataObject.Columns){
				ASColumn ascolumn = (ASColumn)o;
				String jboClassAlias_T = ascolumn.getAttribute("COLTABLENAME");
				if(!jboClassAlias.equalsIgnoreCase(jboClassAlias_T))  continue;
				
				relativeObject.setAttributeValue(ascolumn.getAttribute("COLACTUALNAME")
						,businessObject.getObject(ascolumn.getAttribute("COLNAME")));
			}
			businessObject.setAttributeValue(jboClassName, relativeObject);
		}
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
	public static ALSBusinessProcess createBusinessProcess(HttpServletRequest request,ASDataObject dataObject,JBOTransaction transaction) throws Exception{
		
		return ALSBusinessProcess.createBusinessProcess(request, dataObject
				, BusinessObjectManager.createBusinessObjectManager(transaction));
	}
	
	public BizObjectQuery getListQuery()  throws Exception{
		String jboClass=this.getASDataObject().getJboClass();
		String jboString=ObjectWindowHelper.getJBOQuerySql_Where(this.getASDataObject());
		List<BusinessObject> filterParameters=this.getListFilter();
		
		
		String filterSql="";
		List<BusinessObject> parameterList = new ArrayList<BusinessObject>();
		for(BusinessObject filter : filterParameters){
			String parameterSql="";
			String tableName = filter.getString("ColTableName");
			if(!StringX.isEmpty(tableName)) tableName+=".";
			String colActualName = tableName+filter.getString("ColActualName");
			String colName = filter.getString("ColName");
			String operater = filter.getString("Operater");
			String value1 = filter.getString("Value1");
			String value2 = filter.getString("Value2");
			if(operater.equalsIgnoreCase("In")){//单选
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" in (:"+colName+"))";
				String[] values = value1.split("\\|");
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "in");
				parameter.setAttributeValue("Value", values);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("MultiIn")){//多选
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" in (:"+colName+"))";
				String[] values = value1.split("\\|");
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "multiIn");
				parameter.setAttributeValue("Value", values);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("OrgIn")){//下属机构
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" in (select OB.BelongOrgID from jbo.sys.ORG_BELONG OB where OB.OrgID in (:"+colName+")))";
				String[] values = value1.split("\\|");
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "in");
				parameter.setAttributeValue("Value", values);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("Area")){
				if(StringX.isEmpty(value1)&&StringX.isEmpty(value2)) continue;
				if(value1!=null){
					parameterSql=colActualName+" >= :"+colName+"1";
				}
				if(value2!=null){
					if(StringX.isEmpty(parameterSql))
						parameterSql+=colActualName+" <= :"+colName+"2";
					else parameterSql+= " and "+colActualName+" <= :"+colName+"2";
				}
				parameterSql="("+parameterSql+")";
				
				BusinessObject parameter1 = BusinessObject.createBusinessObject();
				parameter1.setAttributeValue("Name", colName+"1");
				parameter1.setAttributeValue("Operate", "=");
				parameter1.setAttributeValue("Value", value1);
				parameterList.add(parameter1);
				
				BusinessObject parameter2 = BusinessObject.createBusinessObject();
				parameter2.setAttributeValue("Name", colName+"2");
				parameter2.setAttributeValue("Operate", "=");
				parameter2.setAttributeValue("Value", value2);
				parameterList.add(parameter2);
			}
			else if(operater.equalsIgnoreCase("Like")){
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" like :"+colName+")";
				value1 = "%"+value1+"%";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("BeginsWith")){
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" like :"+colName+")";
				value1 = value1+"%";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("NotBeginsWith")){
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" not like :"+colName+")";
				value1 = value1+"%";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("Not")){
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" <> :"+colName+")";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("BigThan")){
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" > :"+colName+")";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("BigEqualsThan")){
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" >= :"+colName+")";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("LessThan")){
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" < :"+colName+")";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			else if(operater.equalsIgnoreCase("LessEqualsThan")){
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" <= :"+colName+")";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			else{
				if(StringX.isEmpty(value1)) continue;
				parameterSql="("+colActualName+" = :"+colName+")";
				BusinessObject parameter = BusinessObject.createBusinessObject();
				parameter.setAttributeValue("Name", colName);
				parameter.setAttributeValue("Operate", "=");
				parameter.setAttributeValue("Value", value1);
				parameterList.add(parameter);
			}
			if(StringX.isEmpty(parameterSql)) continue;
			if(StringX.isEmpty(filterSql))
				filterSql+=" "+parameterSql;
			else 
				filterSql+=" and "+parameterSql;
		}
		if(!StringX.isEmpty(filterSql)){
			filterSql=" ("+filterSql+")";
		}
		else{
			String nofiltersql=getASDataObject().getCustomProperties().getProperty("JboWhereWhenNoFilter");
			if(nofiltersql==null)nofiltersql="";
			jboString+=nofiltersql;
		}
		if(!StringX.isEmpty(filterSql))
			jboString+=" and "+filterSql;
		
		jboString+=ObjectWindowHelper.getJBOQuerySql_OrderGroup(this.getASDataObject());
		BusinessObject[] parameterArray = new BusinessObject[parameterList.size()];
		parameterArray=parameterList.toArray(parameterArray);
		return JBOHelper.getQuery(jboClass, jboString, parameterArray, this.transaction);
	}
	
	public List<BusinessObject> getListFilter()  throws Exception{
		List<BusinessObject> filterParameters = new ArrayList<BusinessObject>();
		ASDataObject dataObject = this.getASDataObject();
		if(dataObject.Filters==null) return filterParameters;
		for(int k=0;k<dataObject.Filters.size();k++){
			ASDataObjectFilter asFilter = (ASDataObjectFilter)dataObject.Filters.get(k);
			if(asFilter.sFilterInputs==null) continue;
			String colName = asFilter.acColumn.getAttribute("ColName");
			
			String sColFilterRefId = dataObject.getColumn(colName).getAttribute("COLFILTERREFID");
			if(sColFilterRefId!=null && sColFilterRefId.length()>0)
				colName = sColFilterRefId;
			String upperCaseColName = colName.toUpperCase();
			String operater = asFilter.sOperator;
			String value1 =asFilter.sFilterInputs[0][1];
			String value2 =asFilter.sFilterInputs[1][1];
			if(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_OP")!=null){
				operater = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_OP").toString(),"UTF-8");
			}
			else if(!StringX.isEmpty(operater) && operater.equalsIgnoreCase("BeginsWith"))
			{
				List<DataElement> params = dataObject.getParameters();
				
				for(DataElement param:params){
					for(int t=0;t<asFilter.sFilterInputs.length;t++){
						if(param.getName().equalsIgnoreCase(asFilter.sFilterInputs[t][0]))
						{
							String tmp = (String)param.getValue();
							if(tmp.startsWith("%")) operater = "Like";
						}
					}
				}
			}
			if(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_VALUE")!=null){
				value1 = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_1_VALUE").toString(),"UTF-8");
			}
			if(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_2_VALUE")!=null){
				value2 = URLDecoder.decode(request.getParameter("DOFILTER_DF_"+ upperCaseColName +"_2_VALUE").toString(),"UTF-8");
			}
			String colActualName = dataObject.getColumnAttribute(colName,"ColActualName");
			String tableName = dataObject.getColumnAttribute(colName,"ColTableName");
			//if(StringX.isEmpty(tableName)) continue;
			
			BusinessObject filterParameter=BusinessObject.createBusinessObject();
			filterParameter.setAttributeValue("ColTableName", tableName);
			filterParameter.setAttributeValue("ColActualName", colActualName);
			filterParameter.setAttributeValue("ColName", colName);
			filterParameter.setAttributeValue("Operater", operater);
			filterParameter.setAttributeValue("Value1", value1);
			filterParameter.setAttributeValue("Value2", value2);
			filterParameters.add(filterParameter);
		}
		return filterParameters;
	}
	
	/**
	 * 创建一个处理器，指定事务处理
	 * @param request
	 * @param dataObject
	 * @param transaction
	 * @return
	 * @throws Exception
	 */
	public static ALSBusinessProcess createBusinessProcess(HttpServletRequest request,ASDataObject dataObject,BusinessObjectManager bomanager) throws Exception{
		String businessProcessClassName = dataObject.getBusinessProcess();
		if(StringX.isEmpty(businessProcessClassName))
			businessProcessClassName = "com.amarsoft.app.als.awe.ow.ALSBusinessProcess";
		Class<?> businessProcessClass = Class.forName(businessProcessClassName);
		ALSBusinessProcess businessProcess = (ALSBusinessProcess)businessProcessClass.newInstance();
		businessProcess.setASDataObject(dataObject);
		businessProcess.setTransaction(bomanager.getTx());
		businessProcess.bomanager=bomanager;
		businessProcess.outputbject = BusinessObject.createBusinessObject();
		if(request!=null){
			businessProcess.setRequest(request);
			
			businessProcess.setCurUser(((RuntimeContext)request.getSession().getAttribute("CurARC")).getUser());
			businessProcess.setConfigure(Configure.getInstance(request.getSession().getServletContext()));
		}
		return businessProcess;
	}
}
